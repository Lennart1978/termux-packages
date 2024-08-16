#!/usr/bin/bash

termux_download() {
	if [[ $# != 3 ]]; then
		termux_error_exit "termux_download(): Invalid arguments - expected \$URL \$DESTINATION \$CHECKSUM"
	fi
	local URL="$1"
	local DESTINATION="$2"
	local CHECKSUM="$3"

	if [[ -f "$DESTINATION" ]] && [[ "$CHECKSUM" != "SKIP_CHECKSUM" ]]; then
		# Keep existing file if checksum matches.
		local EXISTING_CHECKSUM
		EXISTING_CHECKSUM=$(sha256sum "$DESTINATION" | cut -d' ' -f1)
		[[ "$EXISTING_CHECKSUM" == "$CHECKSUM" ]] && return
	fi

	local TMPFILE
	local -a CURL_OPTIONS=(
		--fail
		--retry 10
		--retry-connrefused
		--retry-delay 5
		--speed-limit 10000
		--speed-time 30
		--location
	)
	TMPFILE=$(mktemp "$TERMUX_PKG_TMPDIR/download.${TERMUX_PKG_NAME-unnamed}.XXXXXXXXX")
	if [[ "${TERMUX_QUIET_BUILD-}" == "true" ]]; then
		CURL_OPTIONS+=( --no-progress-meter)
	fi

	echo "Downloading ${URL}"
	if ! curl "${CURL_OPTIONS[@]}" --output "$TMPFILE" "$URL"; then
		local e=1
		local retry=2
		local try
		for try in $(seq "${retry}"); do
			echo "Retrying #${try} download ${URL}"
			sleep 1
			if curl "${CURL_OPTIONS[@]}" --output "$TMPFILE" "$URL"; then
				e=0
				break
			fi
		done
		if [[ "${e}" == 1 ]]; then
			echo "Failed to download $URL" >&2
			return 1
		fi
	fi

	local ACTUAL_CHECKSUM
	ACTUAL_CHECKSUM=$(sha256sum "$TMPFILE" | cut -d' ' -f1)
	if [[ -z "$CHECKSUM" ]]; then
		printf "WARNING: No checksum check for %s:\nActual: %s\n" \
			"$URL" "$ACTUAL_CHECKSUM"
	elif [[ "$CHECKSUM" == "SKIP_CHECKSUM" ]]; then
		:
	elif [[ "$CHECKSUM" != "$ACTUAL_CHECKSUM" ]]; then
		>&2 printf "Wrong checksum for %s\nExpected: %s\nActual:   %s\n" \
			"$URL" "$CHECKSUM" "$ACTUAL_CHECKSUM"
		return 1
	fi
	mv "$TMPFILE" "$DESTINATION"
	return 0
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_download "$@"
fi
