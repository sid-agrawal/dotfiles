function vimack {
   local pattern=$1
   shift
   $EDITOR "+Ack '$pattern' $*" +cfirst
}

function edit-file {
   local file
   file=$(fzf)
   local code=$?
   if [[ $code != 0 ]]; then
      return $code
   fi
   if [[ -z $file ]]; then
      return 1
   fi

   $EDITOR $file
}

function extract-rpm {
   if (( $# != 2 )); then
      echo "Usage: $0 rpm dir"
      return 1
   fi
   local rpm=$1
   local dest=$2

   if [[ ! -d $dest ]]; then
      mkdir -p $dest
   fi
   (cd $dest; rpm2cpio $rpm | cpio -idmv)
}
