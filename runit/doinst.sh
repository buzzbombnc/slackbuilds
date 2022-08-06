# Add a useful unprivileged logger group and user.
if ! group_exists logger && ! user_exists logger; then
    LOGGER_ID=$(find_system_gid_uid both)
    echo "Creating 'logger' with gid/uid $LOGGER_ID."
    groupadd -g $LOGGER_ID logger
    useradd --home-dir /var/empty --gid logger --no-create-home --no-user-group --system --uid $LOGGER_ID logger
fi

# Make sure the .new start files have matching permissions of the existing files.
for I in rc.runsvdir.new; do
    B=`basename $I .new`
    if [ -f etc/rc.d/$B ]; then
        cp -a etc/rc.d/$B etc/rc.d/$I.incoming
        cat etc/rc.d/$I > etc/rc.d/$I.incoming
        mv etc/rc.d/$I.incoming etc/rc.d/$I
    fi
done

config etc/rc.d/rc.runsvdir.new

# Add the autostart to rc.local, if it's not there.
if [ -f etc/rc.d/rc.local ]; then
    if ! grep -q /etc/rc.d/rc.runsvdir etc/rc.d/rc.local; then
        echo "# Start the runsvdir daemon." >> etc/rc.d/rc.local
        echo "if [ -x /etc/rc.d/rc.runsvdir ]; then" >> etc/rc.d/rc.local
        echo "  . /etc/rc.d/rc.runsvdir start" >> etc/rc.d/rc.local
        echo "fi" >> etc/rc.d/rc.local
        echo "" >> etc/rc.d/rc.local
    fi
fi

echo ""
echo "If you want the runsvdir daemon to run at startup:"
echo ""
echo "chmod +x /etc/rc.d/rc.runsvdir"
