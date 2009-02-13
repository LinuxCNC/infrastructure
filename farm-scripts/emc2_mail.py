
"""
This is a Buildbot Change Source that parse EMC2's CVS commit email
"""

import os
import re
from email import message_from_file
from email.Utils import parseaddr
from email.Iterators import body_line_iterator

from zope.interface import implements
from twisted.python import log
from buildbot import util
from buildbot.interfaces import IChangeSource
from buildbot.changes import changes
#from buildbot.changes.maildir import MaildirService
from buildbot.changes.mail import MaildirSource


class EMC2MaildirSource(MaildirSource):
    name = "EMC2 CVS Script 1.0"

    def parse(self, m, prefix):
        """parse email sent by cradek's EMC CVS Script 1.0"""

        log.msg("got an email!")
        log.msg(m)

        # the From: should look like this:  EMC CVS server <cvs-adm@cvs.linuxcnc.org>
        name, addr = parseaddr(m["from"]);
        expected_name = "EMC CVS server"
        expected_addr = "cvs-adm@cvs.linuxcnc.org"
        if name != expected_name:
            log.msg("email is from \"%s\", expected \"%s\"" % (name, expected_name))
            return None
        if addr != expected_addr:
            log.msg("email is from \"%s\", expected \"%s\"" % (addr, expected_addr))
            return None

        # we take the time of receipt as the time of checkin. Not correct,
        # but it avoids the out-of-order-changes issue. See the comment in
        # parseSyncmail about using the 'Date:' header
        when = util.now()

        #
        # the commit notification email looks like this:
        #
        # <message>
        #  <generator>
        #   <name>EMC CIA script</name>
        #   <version>1.0</version>
        #  </generator>
        #  <source>
        #   <project>EMC</project>
        #   <module>emc2/docs/src/gui</module>
        #   <branch>TRUNK</branch>
        #  </source>
        #  <body>
        #   <commit>
        #    <files><file>axis.lyx</file></files>
        #    <author>bigjohnt</author>
        #    <log>minor edit
        #    </log>
        #   </commit>
        #  </body>
        # </message>

        files = []
        module = ""
        branch = ""
        comments = ""
        isdir = 0
        lines = list(body_line_iterator(m))

        while lines:
            line = lines.pop(0)
            log.msg("thinking about line \"%s\"" % line)

            if re.search(r"\<module\>emc2", line):
                module = "emc2"
                continue

            match = re.search(r"\<branch\>([^<]+)", line)
            if match:
                branch = match.group(1)
                continue

            match = re.search(r"\<author\>([^\<]+)\<", line)
            if match:
                author = match.group(1)
                continue

            match = re.search(r"\<files\>(.+)\<\/files\>", line)
            if match:
                f = match.group(1)
                # f begins and ends with the separator, so the split result begins and ends with an empty string
                new_files = re.split(r"(?:</?file>)+", f)
                while new_files:
                    new_file = new_files.pop(0)
                    if new_file:
                        files.append(new_file)

                continue

            match = re.search(r"\<log\>(.*)", line)
            if match:
                comments += match.group(1)
                while lines:
                    line = lines.pop(0)
                    if re.search(r"\<\/log\>", line):
                        break
                    comments += line
                continue

        if module != "emc2":
            log.msg("email contained no module");
            return None

        if not branch:
            log.msg("email contained no branch");
            return None

        if not files:
            log.msg("email contained no files");
            return None

        if not author:
            log.msg("email contained no author");
            return None

        log.msg("accepting change from email:");
        log.msg("    author = %s" % author);
        log.msg("    files = %s" % files);
        log.msg("    comments = %s" % comments);
        log.msg("    branch = %s" % branch);

        # the "branch" value gets used by Buildbot as a CVS Tag, and for TRUNK the proper Tag is None
        if branch == "TRUNK":
            branch = None

        return changes.Change(author, files, comments, when=when, branch=branch)

