#!/bin/bash

version=$2
here=`dirname $0`
dest_dl_dir=$here/binaries
src_dir=$here/src
build_dir=$here/build
pkg_dir=$here/pkg

select_version() {
  if [ -z $version ] ; then
    version=2.9
  fi
  echo "Builing version $version"
}

make_dirs() {
  echo "Creating directories ..."
  mkdir -p $pkg_dir
  mkdir -p $build_dir
  mkdir -p $dest_dl_dir
  mkdir -p $src_dir/usr/bin
}

download() {
  echo "Downloading chrome driver..."
  zip=chromedriver_linux64.zip
  downloaded_file=$dest_dl_dir/$zip
  selected_file=$dest_dl_dir/chromedriver
  if [ ! -f $selected_file ] ; then
    wget -nv http://chromedriver.storage.googleapis.com/$version/$zip -O $downloaded_file || exit 1
    unzip $downloaded_file -d $dest_dl_dir
  else
    echo "  File already downloaded."
  fi
}

build() {
  echo "Processing ..."
  rm -Rf $build_dir
  cp -R $src_dir $build_dir
  find $build_dir -type f -exec sed -i s/%VERSION%/$version/g {} \;
  cp $selected_file $build_dir/usr/bin/chromedriver
  chmod +x $build_dir/usr/bin/chromedriver
}

clean() {
  echo "Cleanning ..."
  rm -Rf $pkg_dir $build_dir $dest_dl_dir
}

package() {
  echo 'Packaging ...'
  dpkg-deb --build $build_dir > /dev/null
  mv $here/build.deb $pkg_dir/selenium-chromedriver-$version.deb	
}

usage() {
  echo "usage:"
  echo "  `basename $0` pkg [ version ]"
  echo "  `basename $0` clean"
}

case $1 in
  clean)
    clean
    ;;
  pkg)
    select_version
    make_dirs
    download
    build
    package
    ;;
  *)
    usage
esac
