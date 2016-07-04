#!/bin/bash

# root_dir=$HOME/data/VOCdevkit/
root_dir=$HOME/data/data_object_image_2/
sub_dir=ImageSets/Main
bash_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # where *.sh exists
# separate datasets to trainval and test
# 0-4000:train, 4001-7480:test
# trainval
dst_file=$bash_dir/trainval.txt
if [ -f $dst_file ]
then
  rm -f $dst_file
fi
tmp_png=$bash_dir/tmp_png.txt
tmp_xml=$bash_dir/tmp_xml.txt
seq -f "%06g" 0 4000 > $tmp_png
cp $tmp_png $tmp_xml

sed -i "s/^/training\/image_2\//g" $tmp_png
sed -i "s/$/.png/g" $tmp_png

sed -i "s/^/training\/label_2_xml_easy\//g" $tmp_xml
sed -i "s/$/.xml/g" $tmp_xml

paste -d' ' $tmp_png $tmp_xml >> $dst_file
rm -f $tmp_png
rm -f $tmp_xml

rand_file=$dst_file.random
cat $dst_file | perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);' > $rand_file
mv $rand_file $dst_file

# test
dst_file=$bash_dir/test.txt
if [ -f $dst_file ]
then
 rm -f $dst_file
fi
seq -f "%06g" 4001 7480 > $tmp_png
cp $tmp_png $tmp_xml

sed -i "s/^/training\/image_2\//g" $tmp_png
sed -i "s/$/.png/g" $tmp_png

sed -i "s/^/training\/label_2_xml_easy\//g" $tmp_xml
sed -i "s/$/.xml/g" $tmp_xml

paste -d' ' $tmp_png $tmp_xml >> $dst_file
rm -f $tmp_png
rm -f $tmp_xml

$bash_dir/../../build/tools/get_image_size $root_dir $dst_file $bash_dir/"test_name_size.txt"


# for dataset in trainval test
# do
#   dst_file=$bash_dir/$dataset.txt
#   if [ -f $dst_file ]
#   then
#     rm -f $dst_file
#   fi
#   for name in VOC2007 VOC2012
#   do
#     if [[ $dataset == "test" && $name == "VOC2012" ]]
#     then
#       continue
#     fi
#     echo "Create list for $name $dataset..."
#     dataset_file=$root_dir/$name/$sub_dir/$dataset.txt
#
#     img_file=$bash_dir/$dataset"_img.txt"
#     cp $dataset_file $img_file
#     sed -i "s/^/$name\/JPEGImages\//g" $img_file
#     sed -i "s/$/.jpg/g" $img_file
#
#     label_file=$bash_dir/$dataset"_label.txt"
#     cp $dataset_file $label_file
#     sed -i "s/^/$name\/Annotations\//g" $label_file
#     sed -i "s/$/.xml/g" $label_file
#
#     paste -d' ' $img_file $label_file >> $dst_file
#
#     rm -f $label_file
#     rm -f $img_file
#   done
#
#   # Generate image name and size infomation.
#   if [ $dataset == "test" ]
#   then
#     $bash_dir/../../build/tools/get_image_size $root_dir $dst_file $bash_dir/$dataset"_name_size.txt"
#   fi
#
#   # Shuffle trainval file.
#   if [ $dataset == "trainval" ]
#   then
#     rand_file=$dst_file.random
#     cat $dst_file | perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);' > $rand_file
#     mv $rand_file $dst_file
#   fi
# done
