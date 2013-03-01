[[ "root" != $(whoami) ]] && echo "not root" && exit

packages=(
    "http://downloads.puppetlabs.com/mac/facter-1.6.17.dmg"
    "http://downloads.puppetlabs.com/mac/hiera-1.1.2.dmg"
    "http://downloads.puppetlabs.com/mac/puppet-3.1.0.dmg"
)

RESULT=''
for package in ${packages[@]}; do
    FILENAME=$(basename ${package})
    which ${FILENAME%%-*\.dmg} > /dev/null
    if [[ $? != 0 ]]; then
        [[ ! -f $FILENAME ]] && curl -O $package 2> /dev/null
        [[ ! -d "/Volumes/${FILENAME/\.dmg/}" ]] && open $FILENAME
        sleep 2 # short wait for mount to settle
        installer -pkg /Volumes/${FILENAME/\.dmg}/${FILENAME/\.dmg/}.pkg -target / > /dev/null
        hdiutil unmount /Volumes/${FILENAME/\.dmg/} -force > /dev/null
        [[ -f $FILENAME ]] && rm $FILENAME
        which ${FILENAME%%-*\.dmg} > /dev/null && RESULT=$RESULT"Package ${FILENAME%%-*\.dmg} installed successfully\n"
    else
        RESULT=$RESULT"Package ${FILENAME%%-*\.dmg} previously installed\n"
    fi
done

puppet resource group puppet ensure=present > /dev/null
puppet resource user puppet ensure=present > /dev/null

echo -e ${RESULT%\\n}
