if ! group_exists docker; then
    DOCKER_GID=$(find_system_gid_uid gid)
    echo "Creating 'docker' with gid $DOCKER_GID."
    groupadd -g $DOCKER_GID docker
fi

config etc/docker/daemon.json.new
config etc/default/docker.new
config etc/rc.d/rc.docker.new
config etc/logrotate.d/docker.new

if [[ ! -d etc/service/dockerd ]]; then
    # If the runit service config doesn't already exist, move our disabled one over.
    mv etc/service/.dockerd etc/service/dockerd
else
    # Otherwise, update all not-'down' files with the latest info and remove the dir.
    find etc/service/.dockerd -name 'down' -delete
    cp -a etc/service/.dockerd/* etc/service/dockerd/
    rm -rf etc/service/.dockerd
fi

# Add Docker to rc.local, if it's not there.
if [[ -f etc/rc.d/rc.local ]] && ! grep -q /etc/rc.d/rc.docker etc/rc.d/rc.local; then
    echo "" >> etc/rc.d/rc.local
    echo "# Start Docker." >> etc/rc.d/rc.local
    echo "[[ -x /etc/rc.d/rc.docker ]] && (. /etc/rc.d/rc.docker start)" >> etc/rc.d/rc.local
    echo "" >> etc/rc.d/rc.local
fi

echo ""
echo "If you want Docker to run at startup:"
echo ""
echo "chmod +x /etc/rc.d/rc.docker"
echo "             OR"
echo "rm /etc/service/dockerd/{down,log/down}"
