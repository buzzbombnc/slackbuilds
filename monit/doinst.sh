config etc/rc.d/rc.monit.new
config etc/monit/monitrc.new

# Add Monit to rc.local, if it's not there.
if [[ -f etc/rc.d/rc.local ]] && ! grep -q /etc/rc.d/rc.monit etc/rc.d/rc.local; then
    echo "" >> etc/rc.d/rc.local
    echo "# Start Monit." >> etc/rc.d/rc.local
    echo "[[ -x /etc/rc.d/rc.monit ]] && (. /etc/rc.d/rc.monit start)" >> etc/rc.d/rc.local
    echo "" >> etc/rc.d/rc.local
fi

echo ""
echo "If you want Monit to run at startup:"
echo ""
echo "chmod +x /etc/rc.d/rc.monit"
