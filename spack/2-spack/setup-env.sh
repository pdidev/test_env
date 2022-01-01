if [ -z "${_sp_initializing:-}" ]; then
	. $SPACK_ROOT/share/spack/setup-env-orig.sh
	
	oldstate="$(set +o)"
	set +e
	if [ -d $SPACK_ROOT/etc/env ]; then
		for i in $SPACK_ROOT/etc/env/*.sh; do
			if [ -r $i ]; then
				. "$i"
			fi
		done
	unset i
	fi
	eval "$oldstate"
fi
