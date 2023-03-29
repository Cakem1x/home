#!/usr/bin/env sh

update_bootstrap_cmd()
{
    BOOTSTRAP_CMD="ln -s ${HOME}/.config/home-manager/${MACHINE_NAME}.nix ${HOME}/.config/home-manager/home.nix"
}

MACHINE_NAME="MACHINE_NAME"
update_bootstrap_cmd

echo "Will bootstrap user via '${BOOTSTRAP_CMD}'. Choose user to bootstrap:"
select MACHINE_NAME in "trnstr" "firefly" "abort"; do
    case $MACHINE_NAME in
        trnstr) update_bootstrap_cmd; $($BOOTSTRAP_CMD); break;;
        firefly) update_bootstrap_cmd; $($BOOTSTRAP_CMD); break;;
        abort) exit;;
    esac
done
