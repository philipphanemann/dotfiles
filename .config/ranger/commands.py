"""User commands for ranger."""

import base64
import os

from ranger.config.commands import yank as DefaultYank


class yank(DefaultYank):
    """Copy file names or paths using OSC 52 when connected over SSH."""

    def execute(self):
        if not os.environ.get("SSH_TTY"):
            return super().execute()

        mode = self.arg(1)
        if mode not in self.modes:
            self.fm.notify("Unknown yank mode: {}".format(mode), bad=True)
            return

        selection = self.get_selection_attr(self.modes[mode])
        if not selection:
            self.fm.notify("Nothing selected to copy", bad=True)
            return

        payload = base64.b64encode(os.fsencode("\n".join(selection)))
        sequence = b"\x1b]52;c;" + payload + b"\x07"

        try:
            with open("/dev/tty", "wb") as terminal:
                terminal.write(sequence)
        except OSError as error:
            self.fm.notify("Could not send path to terminal: {}".format(error), bad=True)
            return

        self.fm.notify("Copied {} item(s) to the terminal clipboard".format(len(selection)))
