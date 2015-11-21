#!/bin/sh

clock()
{
	date '+%I:%M:%S %p | %m.%d.%Y'
}

workspace()
{
	raw=$(bspc control --get-status)
	buf=""

	for string in "${raw[@]}" ; do
		IFS=':' read -a arr <<< "$string"

		for part in "${arr[@]}" ; do

			# focused, filled
			if [[ ${part:0:1} == "O" ]] ; then
				buf=${buf}\ %{F#fffcd786}${part:1:4}
			fi

			# unfocused, filled
			if [[ ${part:0:1} == "o" ]] ; then
				buf=${buf}\ %{F#ff7c5826}${part:1:4}
			fi

			# focused, empty
			if [[ ${part:0:1} == "F" ]] ; then
				buf=${buf}\ %{F#fffcd786}${part:1:4}
			fi

			# unfocused, empty
			if [[ ${part:0:1} == "f" ]] ; then
				buf=${buf}\ %{F#ff707070}${part:1:4}
			fi
		done
	done

	echo $buf
}

while true ; do
	buf=""
	buf="${buf} $(workspace)"
	buf="${buf} %{r}%{F#ffb0b0b0}$(clock)"

	# pipe output
	echo " ${buf} "

	# reset output color
	#echo -ne "\e[0m"

	sleep 1
done
