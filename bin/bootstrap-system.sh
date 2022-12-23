#!/usr/bin/env sh

update_bootstrap_cmd()
{
    BOOTSTRAP_CMD="sudo ln -s ${HOME}/.config/nix_machines/${MACHINE_NAME}.nix /etc/nixos/configuration.nix"
}

MACHINE_NAME="MACHINE_NAME"
update_bootstrap_cmd

echo "Will bootstrap system via '${BOOTSTRAP_CMD}'. Choose system to bootstrap:"
select MACHINE_NAME in "trnstr" "firefly" "abort"; do
    case $MACHINE_NAME in
        trnstr) update_bootstrap_cmd; $($BOOTSTRAP_CMD); break;;
        firefly) update_bootstrap_cmd; $($BOOTSTRAP_CMD); break;;
        abort) exit;;
    esac
done
