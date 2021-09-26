#!/usr/bin/env bash

set -ue

function calcChecksum() # $@: data
{
	local -i _sum=0

	while (( ${#} > 0 ))
	do
		_sum+="0x${1}"
		shift
	done

	(( _sum = ((_sum ^ 0xFF) + 1) & 0xFF ))

	printf '%02X' "${_sum}"
}

function convHexLineFormat() # $@: data
{
	echo -n ':' "${hexline[@]}" | tr -d ' '
}

declare -ri maxLength=64 # Total length of version string
declare -ri lineWidth=16 # 16 byte data field per line

declare -i i
declare -i j

declare -- sysverStr=''
declare -a hex=()
declare -a hexline=()
declare -a data=()

read -p "Input System Version (<= ${maxLength} Chars) > " sysverStr

if (( (${#sysverStr} > 0) && (${#sysverStr} <= maxLength) ))
then
	# 1st Step [Convert hex code]
	for (( i = 0; i < ${#sysverStr}; i++ ))
	do
		data+=( "$(printf '%02X' "\"${sysverStr:${i}:1}")" )
	done

	# 2nd Step [Data field padding]
	for (( i = ${#sysverStr}; i < maxLength; i++ ))
	do
		data+=( "00" )
	done

	# 3rd Step [Record line generate]
	for (( i = 0; i < maxLength; i += lineWidth ))
	do
		hexline=()

		declare -i lineByte

		if (( (maxLength - i) > lineWidth ))
		then
			lineByte=lineWidth
		else
			lineByte=maxLength-i
		fi

		# Set byte count
		hexline+=( "$(printf '%02X' "${lineByte}")" )

		# Set address
		hexline+=( $(printf '%04X' "${i}" | sed -e 's/\(..\)\(..\)/\1 \2/g') )

		# Set record type (Data)
		hexline+=( '00' )

		# Set data field
		for (( j = i; j < (i + lineByte); j++ ))
		do
			hexline+=( "${data[${j}]}" )
		done

		# Calc and set checksum
		hexline+=( "$(calcChecksum "${hexline[@]}")" )

		# Register hex
		hex+=( "$(convHexLineFormat "${hexline[@]}")" )
	done

	# 4th Step [Insert EOF record]
	## Set byte count
	hexline=( '00' )
	## Set address
	hexline+=( '00' '00' )
	## Set record type (EOF)
	hexline+=( '01' )
	## Calc and set checksum
	hexline+=( "$(calcChecksum "${hexline[@]}")" )
	## Register into hex
	hex+=( "$(convHexLineFormat "${hexline[@]}")" )

	# Final Step [Output hexfile]
	echo ${hex[@]} | sed -e 's/ /\n/g'
else
	echo 'Error: Input string length is out of range! (=0 or >32).' >&2
fi

