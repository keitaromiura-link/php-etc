#!/bin/bash


# 引数の存在確認
# なければエラーで終了
if [ $# -ne 1 ]; then
	echo "指定された引数は$#個です。" 1>&2
	echo "実行するには1個の引数が必要です。" 1>&2
	exit 1
fi

# 引数の有効性確認
# すべて小文字でa-z 20文字以内

if [[ "$1" =~ ^[a-z0-9]+$ ]]; then
	echo $1 1>&2
else
	echo "入力された引数は利用できません。" 1>&2
	echo "小文字で入力してください" 1>&2
	exit 1
fi

# 引数の重複確認
# ../application/以下に同様のディレクトリが無いことを確認する
if [[ -e "../application/$1" ]]; then
	echo "すでにアプリケーションが存在します" 1>&2
	exit 1
fi

# ../vendor/codeigniter/framework/applicationディレクトリを名前を変えて../applicationディレクトリにコピーする
echo "making directory ../application/$1" 1>&2
cp -r ../vendor/codeigniter/framework/application ../application/$1 1>&2
echo "done;" 1>&2

#  ./vendor/codeigniter/framework/index.phpファイルを名前を変えて ../pubilc_htmlディレクトリにコピーする
echo "making file ../public_html/${1}.php" 1>&2
cp ../vendor/codeigniter/framework/index.php ../public_html/${1}.php 1>&2
echo "done;" 1>&2

echo "checking file ../public_html/${1}.php" 1>&2
#  ./index.phpのファイルの中身を変更する
# $system_path = 'system'; → $system_path = '../vendor/codeigniter/framework/system';
sed -i -e "s#\$system_path = 'system';#\$system_path = '../vendor/codeigniter/framework/system';#g" ../public_html/${1}.php 1>&2
echo "." 1>&2
# $application_folder = 'application'; → $application_folder = '../application/XXXXX';
sed -i -e "s#\$application_folder = 'application';#\$application_folder = '..\/application\/${1}';#g" ../public_html/${1}.php 1>&2
echo "done;" 1>&2

echo "finished !"
exit 0
