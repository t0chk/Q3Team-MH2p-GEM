#!/bin/ksh
#shell script to read out the version information for the GEM

projectstring=`cat /etc/project.txt`

#get SKU / REV
echo "SKU-REV: $(cat /dev/nvsku/sku)-$(cat /dev/nvsku/rev)"

#get APP version
echo -n 'APP: '
head -1 /mnt/app/img_ver.txt | sed "s/^#//"
#get Branch
echo -n 'Branch:'
cat /mnt/app/version_info.txt | grep Branch | cut -d '=' -f 2
#get Changelist or Label
CHANGELIST=`cat /mnt/app/version_info.txt | grep "Up to CL" | cut -d '=' -f 2`
if [ ! -z $CHANGELIST ]; then
        echo -n 'Changelist:'
        cat /mnt/app/version_info.txt | grep "Up to CL" | cut -d '=' -f 2
else
        echo -n 'Label:'
        cat /mnt/app/version_info.txt | grep "Label" | cut -d '=' -f 2
fi
#get Framework
echo -n 'Framework (MMX):'
cat /mnt/app/version_info.txt | grep Framework | cut -d '=' -f 2
echo -n 'GraphicsServices:'
cat /mnt/app/version_info.txt | grep GraphicsServices | cut -d '=' -f 2
#get J9 version
echo -n 'J9:'
cat /mnt/app/version_info.txt | grep J9 | cut -d '=' -f 2
#get DSI
echo -n 'DSI:'
cat /mnt/app/version_info.txt | grep "DSI =" | cut -d '=' -f 2
#get Radiodata
echo -n 'RSDB:'
if [[ -e /mnt/persist_new/swup/filecopy/versions/RSDB.ver ]]; then
    cat /mnt/persist_new/swup/filecopy/versions/RSDB.ver | grep "version =" | cut -d '=' -f 2
else
    echo "No information available"
fi
#get RdvController
echo -n 'RdvController - Builddate/CL:'
use -i /mnt/app/eso/bin/apps/rdv_controller | grep DATE | cut -d= -f 2
use -i /mnt/app/eso/bin/apps/rdv_controller | grep CHANGELIST | cut -d= -f 2
#get EsoPosProvider
echo -n 'EsoPosProvider - Builddate/CL:'
use -i /mnt/app/eso/bin/apps/esoposprovider | grep DATE | cut -d= -f 2
use -i /mnt/app/eso/bin/apps/esoposprovider | grep CHANGELIST | cut -d= -f 2
#get Navigation
echo -n 'Navigation: '
if [ -d /mnt/app/navigation/aw_tts_nav ] ; then
  cat /mnt/app/navigation/Navigation_version.txt | grep -i 'name =' | cut -d '=' -f 2
else
  use -i /mnt/app/navigation/navStartup | grep ^VERSION | cut -d= -f 2
fi
#get Navigation database
REGION=`cat /mnt/app/version_info.txt | grep "Region" | cut -d '=' -f 2`
if [[ "$REGION" != " AS" ]] && [[ "$REGION" != " CT" ]] && [[ "$REGION" != " KR" ]] && [[ -e /mnt/navdb/database/ndscache/package.db ]]; then
        echo -n 'NavDB: '
	/scripts/getHereNavdbVersion.sh /mnt/navdb/database/ndscache/package.db
	echo ''
elif [[ -e /mnt/navdb/database/ndscache/map_version.txt ]]; then
	echo -n 'NavDB: '
	cat /mnt/navdb/database/ndscache/map_version.txt
	echo ''
fi
#get Asia Navigation database
case `head -1 /mnt/app/img_ver.txt` # find out brand
in
  *_MMX2P_AU_*) THEBRAND=AU ;;
  *_MMX2P_VW_*) THEBRAND=VW ;;
  *_MMX2P_PAG_*) THEBRAND=PO ;;
  *_MMX2P_LB_*) THEBRAND=LB ;;
esac
if [[ -e /mnt/navdb/db/VERSION/SR_${THEBRAND}/DBInfo.txt ]]; then # location of DBInfo.txt in new DB structure
        echo -n 'NavDB: '
        cat /mnt/navdb/db/VERSION/SR_${THEBRAND}/DBInfo.txt | grep DBName | cut -d= -f 2 | sed "s/\"//g"
elif [[ -e /mnt/navdb/db/VERSION/DBInfo.txt ]]; then # location of DBInfo.txt in old DB CU structure
        echo -n 'NavDB: '
        cat /mnt/navdb/db/VERSION/DBInfo.txt | grep DBName | cut -d= -f 2 | sed "s/\"//g"
elif [[ -e /mnt/navdb/VERSION/SR_${THEBRAND}/DBInfo.txt ]]; then # location of DBInfo.txt in old DB REM structure
        echo -n 'NavDB: '
        cat /mnt/navdb/VERSION/SR_${THEBRAND}/DBInfo.txt | grep DBName | cut -d= -f 2 | sed "s/\"//g"
fi
#get Navigation styles
if [[ -d /mnt/app/navigation/resources/app ]]; then
	echo '-----------'
	echo 'Navigation styles:'
	NAV_OEM=$(cd /mnt/app/navigation/resources/app; ls -d * | head -1)
	MAPSTYLES_LIST=$(cd /mnt/app/navigation/resources/app/${NAV_OEM}; ls -d *)
	for reg in ${MAPSTYLES_LIST}
	do
		vers=$(head -1 /mnt/app/navigation/resources/app/${NAV_OEM}/${reg}/version-cfg.txt)
		echo $reg = $vers
	done
	echo '-----------'
fi

# EggnogDB
echo -n "EggnogDB version: "
if [[ -e /scripts/getEggnogDBVersionInfo.sh ]]; then
   /scripts/getEggnogDBVersionInfo.sh
else
   echo "No information available"
fi

#get Truffles database information
echo '-----------'
TRUFFLES_BUILD_ID=$(use -i /eso/bin/apps/esosearch | grep BUILDID | cut -d '=' -f 2)
echo "Truffles:$TRUFFLES_BUILD_ID"
if [[ -e /mnt/navdb/truffles/db/common/version.txt ]]; then
	# reformat Truffles version.txt file to match eso Testclient format (no spaces, no quotes, colons as field delimiter)
        cat /mnt/navdb/truffles/db/common/version.txt | cut -d '=' -f 1 -f 2 | sed "s/\"//g" |  sed "s/ //g" | sed "s/=/:/g" | sed "s/^/TrufflesDB./g"
elif [[ -e /mnt/navdb/truffles/db/version.txt ]]; then
	echo 'Attention! You seem to have an out-dated truffles DB (plain structure). '
	echo 'Consider following these steps:'
	echo '1) Update to the latest truffles DB.'
	echo '2) Delete old database structure (plain structure) in GEM/mmx/truffles.'
	cat /mnt/navdb/truffles/db/version.txt
	echo '-----------'
else
	echo 'Truffles: No version information available.'
fi
echo '-----------'

# synvo_SpeechTranscriptionService 
echo -n 'synvo_SpeechTranscriptionService: '
if [[ -e /eso/bin/apps/synvo_SpeechTranscriptionService ]]; then
        use -i /eso/bin/apps/synvo_SpeechTranscriptionService | grep ^VERSION | cut -d= -f 2
else
        echo "No information available"
fi

#get esoSpeechApp
echo -n 'esoSpeechApp: '
if [[ -e /mnt/app/eso/bin/apps/esoSpeechApp ]]; then
	use -i /mnt/app/eso/bin/apps/esoSpeechApp | grep ^VERSION | cut -d= -f 2
else
	echo "No information available"
fi

#get SpeechLauncher
echo -n 'SpeechLauncher: '
if [[ -e /mnt/app/eso/bin/apps/SpeechLauncher ]]; then
	use -i /mnt/app/eso/bin/apps/SpeechLauncher | grep ^VERSION | cut -d= -f 2
else
	echo "No information available"
fi

echo -n 'Speech: '
if [[ -e /mnt/app/speech/libAudioEngineering.so ]]; then
	use -i /mnt/app/speech/libAudioEngineering.so | grep VERSION | cut -d= -f 2
else
	echo "No information available"
fi

#get Speech Resources
if [[ -e /mnt/speech/tts/data_EU/version.info ]]; then
	echo -n 'Speech resources: '
	cat /mnt/speech/tts/data_EU/version.info | grep svn_tag | cut -d '=' -f 2 | sed "s/\"//g"
elif [[ -e /mnt/speech/tts/data_ROW/version.info ]]; then
	echo -n 'Speech resources: '
	cat /mnt/speech/tts/data_ROW/version.info | grep svn_tag | cut -d '=' -f 2 | sed "s/\"//g"
elif [[ -e /mnt/speech/tts/data/version.info ]]; then
	echo -n 'Speech resources: '
	cat /mnt/speech/tts/data/version.info | grep svn_tag | cut -d '=' -f 2 | sed "s/\"//g"
fi
# get Speech VDE Resources
if ls /mnt/navdb/speech/sr/vde/*/common/content.pkg>/dev/null 2>&1; then
	SPEECH_RES_REGION=$(ls /mnt/navdb/speech/sr/vde)
        for REGION_NAME in $SPEECH_RES_REGION ; do
            echo -n "Speech VDE resources (${REGION_NAME} common):"
            grep -i SWUP_VERSION /mnt/navdb/speech/sr/vde/${REGION_NAME}/common/content.pkg | cut -d '=' -f 2
        done
fi
#get SpeechNLU
if [[ -e /eso/lib/libesoSem.so ]]; then
	echo -n 'SpeechNLU: '
	use -i /eso/lib/libesoSem.so | grep ^VERSION | cut -d= -f 2
fi

#get SSE
if [[ -e /mnt/app/eso/bin/apps/sseProc ]]; then
	echo -n 'sseProc: '
	use -i /mnt/app/eso/bin/apps/sseProc | grep ^VERSION | cut -d= -f 2
fi

#get Audiomanager
if [[ -e /mnt/app/eso/bin/apps/audioProc ]]; then
	echo -n 'Audiomanager: '
	use -i /mnt/app/eso/bin/apps/audioProc | grep ^VERSION | cut -d= -f 2
fi

#get HMI
echo -n 'HMI:'
if [[ -e /mnt/app/version_info.txt ]]; then
   cat /mnt/app/version_info.txt | grep HMI | cut -d '=' -f 2
else
   echo "No information available"
fi

#get TextToolVersion
if [[ -e /eso/hmi/TTVersion.properties ]]; then
	echo -n 'TextToolVersion: '
	cat /eso/hmi/TTVersion.properties | grep 'TextToolVersion' | cut -d ':' -f 2
else
   echo "No information available"
fi
#get TextToolSDSVersion
if [[ -e /eso/hmi/TTVersionSDS.properties ]]; then
	echo -n 'SDS-TextToolVersion: '
	cat /eso/hmi/TTVersionSDS.properties | grep 'TextToolSDSVersion' | cut -d ':' -f 2
else
   echo "No information available"
fi

#get GCT version
echo -n 'GCT version: '
if [[ -d /mnt/app/speech/hmi ]]; then
	GCT_VERSION_PATH=$(ls -d /mnt/app/speech/hmi/??_?? | head -1)
	if [[ ! -z ${GCT_VERSION_PATH} ]] && [[ -e ${GCT_VERSION_PATH}/version.txt ]]; then
		if grep -q ^GCT= ${GCT_VERSION_PATH}/version.txt; then
			grep ^GCT= ${GCT_VERSION_PATH}/version.txt | cut -d '=' -f 2
		fi
	else
		echo "No information available"
	fi
else
	echo "No information available"
fi

#get voice_encoder_app
echo -n 'VoiceEncoderApp: '
if [[ -e /mnt/app/eso/bin/appps/voice_encoder_app ]]; then
   use -i /mnt/app/eso/bin/apps/voice_encoder_app | grep VERSION | cut -d= -f 2
else
   echo "No information available"
fi

#get Gracenote database
if [[ -e /mnt/gracenotedb/database.fileinfo ]]; then
	echo -n 'GracenoteDB:'
	cat /mnt/gracenotedb/database.fileinfo  | grep "Version" | cut -d '=' -f 2
fi
#get Gracenote Revision
if [[ -e /mnt/gracenotedb/database/rev.txt ]]; then
	echo -n 'Gracenote: '
	cat /mnt/gracenotedb/database/rev.txt | head -1
fi
#get Nvidia drop
echo -n 'Nvidia:'
cat /mnt/app/version_info.txt | grep Nvidia | cut -d '=' -f 2

#assumption: either MME or MM2 or Cinemo is used (never in parallel)
if grep -q "Cinemo Version" /mnt/app/version_info.txt; then
    echo -n 'Cinemo: '
    cat /mnt/app/version_info.txt | grep "Cinemo Version" | cut -d '=' -f 2
else
    if grep -q MM2 /mnt/app/version_info.txt; then
        #get MME2 version
        echo -n 'MME2 version: '
        cat /mnt/app/version_info.txt | grep "MM2 Version" | cut -d '=' -f 2
    else
        #get MME build date
        echo -n 'MME build date: '
        if [[ -e /mnt/app_version_info.txt ]]; then
            cat /mnt/app/version_info.txt | grep "MME Build" | cut -d '=' -f 2
        else
            echo "No information available"
        fi

        #get MME version
        echo -n 'MME version: '
        if [[ -e /mnt/app_version_info.txt ]]; then
            cat /mnt/app/version_info.txt | grep "MME Version" | cut -d '=' -f 2
        else
            echo "No information available"
        fi
    fi
fi

#get NMSDK version
if [[ -e /armle/usr/sbin/io-media-nvidia-dynamic ]]; then
	echo -n 'NMSDK: '
	use -i /armle/usr/sbin/io-media-nvidia-dynamic | grep "NMSDK" | cut -d '=' -f 2
fi
#get exFAT-Library
if [[ -e /lib/dll/fs-exfat.so ]]; then
        echo -n 'exFAT-Library: '
        use -i /lib/dll/fs-exfat.so | grep ^DATE | cut -d= -f 2
fi
#get Google Earth version
if [[ -e /mnt/app/gemib/gemib ]]; then
	echo -n 'Google Earth: '
	if [ `use -i /mnt/app/gemib/gemib | grep VERSION | grep '"'` ]; then
		use -i /mnt/app/gemib/gemib | grep VERSION | cut -d '"' -f2
	else
		use -i /mnt/app/gemib/gemib | grep VERSION | cut -d '=' -f2
	fi
fi
#get Streetview version
if [[ -e /mnt/app/streetview/streetview ]]; then
	echo -n 'Streetview: '
	use -i /mnt/app/streetview/streetview | grep VERSION |cut -d '=' -f2
fi
#get MOST video split driver version
if [[ -e /sbin/devp-iso-mmx ]]; then
	echo -n 'devp-iso-mmx: '
	use -i /sbin/devp-iso-mmx | grep DATE | cut -d '=' -f 2
fi
#get GPS firmware version
if [[ -e /scripts/getGpsVersion.sh ]]; then
	/scripts/getGpsVersion.sh
fi
if [ $(cat /dev/ooc/startup) == "test" ]; then
    echo "Region Settings not available in BIOS Mode"
else
    # get currently coded region settings
    export LD_LIBRARY_PATH=/proc/boot:/lib:/usr/lib:/eso/lib
    export IPL_CONFIG_DIR=/etc/eso/production 
    set -A VARIANT_NAVIGATION_ARRAY "Keine" "EU" "NAR" "MSA" "Korea" "China" "Japan" "AsiaPacific" "Australia" "South Afrika" "NEAST" "NMAfrica" "MEAST" "CentralAsia" "India" "Israel" "Taiwan" "MSA 2" "China 2" "China 3" "reserved" "--"
    VARIANT_NAVIGATION_INDEX=$(printf "%d\n" "0x$(pc b:0x5f22:0x0600:3)")
    if [[ $VARIANT_NAVIGATION_INDEX -gt 20 ]]; then VARIANT_NAVIGATION_INDEX=21; fi
    echo "Coded Laendervariante Navigation: ${VARIANT_NAVIGATION_ARRAY[VARIANT_NAVIGATION_INDEX]}"

    set -A VERKAUFSLAND_HMI $(pc b:0x5f22:0x09cb)
    echo "Coded Verkaufsland HMI: ${VERKAUFSLAND_HMI[3]}"

    set -A VERKAUFSLAND_MEDIA $(pc b:0x5f22:0x0B49)
    echo "Coded Verkaufsland Media: ${VERKAUFSLAND_MEDIA[3]}"

    set -A REGION_ARRAY "Europe/Rest" "Europe" "North America" "Rest of World" "China" "Japan" "Korea" "Asia" "Taiwan" "--"
    REGION_INDEX=$(printf "%d\n" "0x$(pc i:678364556:504)")
    if [[ $REGION_INDEX -gt 8 ]]; then REGION_INDEX=9; fi
    echo "Coded Region: ${REGION_ARRAY[$REGION_INDEX]}"
fi

