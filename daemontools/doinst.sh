#!/bin/bash

configdel() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  else
    rm $NEW
  fi
}

# Make sure the .new start files have matching permissions of the existing files.
for I in rc.svscan.new; do
	B=`basename $I .new`
	if [ -f etc/rc.d/$B ]; then
		cp -a etc/rc.d/$B etc/rc.d/$I.incoming
		cat etc/rc.d/$I > etc/rc.d/$I.incoming
		mv etc/rc.d/$I.incoming etc/rc.d/$I
	fi
done

( cd etc/rc.d
  configdel rc.svscan.new
)

# Add the autostart to rc.local, if it's not there.
if [ -f etc/rc.d/rc.local ]; then
	if ! grep -q /etc/rc.d/rc.svscan etc/rc.d/rc.local; then
		echo "# Start the svscan daemon." >> etc/rc.d/rc.local
		echo "if [ -x /etc/rc.d/rc.svscan ]; then" >> etc/rc.d/rc.local
		echo "  (. /etc/rc.d/rc.svscan start)" >> etc/rc.d/rc.local
		echo "fi" >> etc/rc.d/rc.local
		echo "" >> etc/rc.d/rc.local
	fi
fi

echo ""
echo "If you want the svscan daemon to run at startup:"
echo ""
echo "chmod +x /etc/rc.d/rc.svscan"
