#source ./clone.sh
GIT="C:\Program Files (x86)\Git\bin\git.exe"
#Repository Details
log_path="C:\sarvam_git\log"
past_log_path="C:\sarvam_git\log\past.log"
present_log_path="C:\sarvam_git\log\present.log"
#past_log_path=$log_path\past.log
#present_log_path=$log_path\present.log
user_name="sarvamvasanth"
rep_name="test-repo"
url="git@github.com:$user_name/$rep_name.git"
first_clone=0
echo $past_log_path
echo $present_log_path

function clone()
{
	first_clone=1
	echo "Cloneing Process Plz wait..."
	#Cloning all files from remote repository to the current folder
	"$GIT" clone $url
	echo "Cloning Completed"
	cd $rep_name
	"$GIT" log --pretty=format:"%H" > "$past_log_path"
	echo "logs are saved"
}
function commit_files()
{
	touch fresh1.java fresh2.java
	echo "basha" >> fresh1.java
	echo "vasanth" >> fresh2.java
	#"$GIT" add asai.txt
	"$GIT" add fresh1.java
	"$GIT" add fresh2.java
	"$GIT" add asai.txt
	"$GIT" commit -m 'latest commits'
	"$GIT" push origin master
}
function log_method()
{
	commit_files
	echo "please wait a seconds"
	"$GIT" pull
	"$GIT" log --pretty=format:"%H" > "$present_log_path"
	echo "updated logs are saved"

}
function log_compare()
{
	#temp_count1=$(cut -d' ' -f1  <<< $(wc -l $("$past_log_path")))
	temp_count1=$(cut -d' ' -f1  <<< $(wc -l "$past_log_path"))
	#temp_count2=$(cut -d' ' -f1  <<< $(wc -l $("$present_log_path")))
	temp_count2=$(cut -d' ' -f1  <<< $(wc -l "$present_log_path"))
	#past_count1= $(`expr $past_count + 1`)
	past_count=`expr $temp_count1 + 1`
	present_count=`expr $temp_count2 + 1`
	#echo $past_count1
	echo $past_count
	echo $present_count
	if [ $past_count -eq $present_count ]; then
		echo "equal"
		#echo $past_count
	else
		#echo $present_count 
	    echo "Not equal"
		count_diff=`expr $present_count - $past_count `
		echo `expr $present_count - $past_count `
		loop_count=1
		echo "count diff $count_diff"
		while read line           
		do  
		if [ $loop_count -le $count_diff ]; then
		
			ln=$line
			echo $loop_count
			#echo $ln
			#echo "current working directory --" `pwd`
			fname=$("$GIT" diff-tree --no-commit-id --name-only -r $ln)
			echo $fname
			loop_count=`expr $loop_count + 1`
		else
			break;
		fi
		done < "$present_log_path" 
	fi;
}
if [ $first_clone -eq 0 ]; then
	clone
fi
log_method
log_compare
echo "before tagging"
"$GIT" tag
echo "last tag"
last_tag=$("$GIT" describe --abbrev=0 --tags )
echo $last_tag
tag_value=`expr $last_tag + 1`
echo $tag_value
#tag_value = 0.1
"$GIT" tag -a "$tag_value" -m 'This version is successfully complete verified -->No Error'
#$GIT"  -a v1.5 "temp_count2"
"$GIT" push origin --tags
echo "after tagging"
"$GIT" tag
read