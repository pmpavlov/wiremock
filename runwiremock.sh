# AUTHOR	: Des McCarter @BJSS
# DATE		: 22/08/2017
# DESCRIPTION	: Downloads the wiremock JAR into the jar folder and executes it

WIREMOCK_VERSION="2.8.0"
OUTFILE="wiremock-standalone-${WIREMOCK_VERSION}.jar"
OUTFOLDER="../wiremock/jar"
LOGFOLDER="../wiremock/logs"
DEFAULTPORT=5555
PORT="${DEFAULTPORT}"
#

# check args ...

if [ ! "a${*}" = "a" ]
then

	while [ ! "a${1}" = "a" ]
	do
		if [ "${1}" = "-port" ]
		then
			shift

			if [ "a${1}" = "a" ]
			then
				echo "[ERR] -port option requires a port number"
				exit 1
			fi

			PORT="${1}"

			echo "Port set to ${PORT}"
		fi

		shift
	done
fi

function pause(){

	let seconds=10

	let count=1

	while [ "${count}" -lt "${seconds}" ]
	do
		echo -n "${count} "

		let count="${count}+1"

		sleep 1
	done

	echo
}

# if it does not exist then download it ...

if [ ! -f "${OUTFOLDER}/${OUTFILE}" ]
then
	if [ ! -d "${OUTFOLDER}" ]
	then
		mkdir -p "${OUTFOLDER}"

		if [ ! "$?" -eq "0" ]
		then
			echo "[ERR] Creating folder ${OUTFOLDER}"
			exit 1
		fi
	fi

	echo "Downloading ${OUTFILE}"

	# Download ...
	curl "http://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/${WIREMOCK_VERSION}/${OUTFILE}" -o "${OUTFOLDER}/${OUTFILE}"
else
	echo "File ${OUTFILE} exists"
fi

if [ ! -d "${LOGFOLDER}" ]
then
	mkdir -p "${LOGFOLDER}"
fi

echo "Executing WIREMOCK ... on port ${PORT}"

nohup java -jar "${OUTFOLDER}/${OUTFILE}" --port ${PORT} --verbose --local-response-templating --root-dir "../wiremock" >> "${LOGFOLDER}/wiremock.log" 2>&1 &

pause
