[[ "root" != $(whoami) ]] && echo "not root" && exit

packages=(
    "http://downloads.puppetlabs.com/mac/facter-1.6.17.dmg"
    "http://downloads.puppetlabs.com/mac/hiera-1.1.2.dmg"
    "http://downloads.puppetlabs.com/mac/puppet-3.1.0.dmg"
)

RESULT=''
for package in ${packages[@]}; do
    FILENAME=$(basename ${package})
    [[ ! -f $FILENAME ]] && curl -O $package 2> /dev/null
    [[ ! -d "/Volumes/${FILENAME/\.dmg/}" ]] && open $FILENAME
    sleep 2 # short wait required before unmount
    which ${FILENAME%%-*\.dmg} > /dev/null
    [[ $? != 0 ]] && installer -pkg /Volumes/${FILENAME/\.dmg}/${FILENAME/\.dmg/}.pkg -target / > /dev/null
    hdiutil unmount /Volumes/${FILENAME/\.dmg/} -force > /dev/null
    [[ -f $FILENAME ]] && rm $FILENAME
    which ${FILENAME%%-*\.dmg} > /dev/null && RESULT=$RESULT"Package ${FILENAME%%-*\.dmg} installed succesfully\n"
done
echo -e ${RESULT%\\n}
