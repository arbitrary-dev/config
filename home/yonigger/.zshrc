# Prevent Wine from adding menu entries and desktop links.
export WINEDLLOVERRIDES='winemenubuilder.exe=d'

export PATH=~/.scripts:/work/scripts/linux:$PATH
export TXT=/misc/text

# aliases

alias rt='scr rtorrent rtorrent'
alias ir='scr irssi irssi'
alias nh='scr nethack ssh nethack@alt.org'
alias vm-git='scr vm-git ~/vm/vm-git'

alias fm-hanako='scr fm-hanako mplayer mms://hdv4.nkansai.tv/hanako'
alias fm-hanako1='fm-hanako -ao alsa:device=mono'
alias limbikfreq='scr limbikfreq mplayer http://74.208.145.88:8000/96.aac'
alias limbikfreq1='limbikfreq -ao alsa:device=mono'

alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'

alias sf='screenfetch -N'
alias nc=ncmpcpp

vt() {
	local opts
	[[ $1 = +* ]] && opts=$1 && shift
	vim $opts $TXT/$1
}

join_by() { local IFS="$1"; shift; echo "$*"; }

todo() {
	local t=$(join_by - $0 $*)
	vt "$t"
}

split-audio() {
  if (( ! $# )); then
    cat <<EOF
Splits audio files using cue
Usage: ${funcstack[1]} [options] <cue> <file>
$(_param -of "flac|ape|mp3" "Output audio format (Default derived from input file extension)")
$(_param "-d|--dir" "dir" "Output directory")
$(_param "-s|--short" "Short title format: %n %t (Default: %n %a - %t)")
EOF
    return 1
  fi

  local cue
  local file
  local out_dir
  local out_fmt
  local title_fmt="%n %p - %t"

  while (( $# )); do
  case "$1" in
    -of)
      out_fmt=$2
      shift ;;

    -d|--dir)
      out_dir=$2
      shift ;;

    -s|--short)
      title_fmt="%n %t" ;;

    *)
      if [[ $1 = *.cue ]]; then
        cue=$1
      elif [[ $1 = *.* ]]; then
        file=$1
      else
        echo "Unknown argument \"$1\"!"
        return 1
      fi
  esac
  shift
  done

  [[ -z $cue ]] && echo "No .cue file was provided!" && return 1
  [[ -z $file ]] && echo "No audio file was provided!" && return 1

  [[ -z $out_fmt ]] && out_fmt=${file##*.}

  shnsplit -f $cue $file -o $out_fmt -t $title_fmt ${out_dir:+-d} $out_dir
}
