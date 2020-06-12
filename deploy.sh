#here the code for identify the merge commit to identiy the which plane have commit and then run the commands to towards that specific components
#like if the commit is related to control-plane 
#then do cd control-plane/
#        terraform init
#        terraform plan
#        terraform apply --auto-approve (here for pro branch need to have the approver for plan)
#        (it will do the specific changes like which block of code is change then terraform is smart to do specific change only 
#        like if change is related to instacen then it will run only instance block and other block is remain as it is likewise for other blocks
#here once know the which block is change then call the specific function and that function take some parameter like directory and then run the specifc commands

# declaring an array, components []
declare -a components=()

# we are only interested in the last merged commit in this repository, 
# if the git show output is not a merged commit, this script will do nothing
from=$(git show | awk '{if($1=="Merge:"){print $2}}')
to=$(git show | awk '{if($1=="Merge:"){print $3}}')

# we need the last commit and the commit previous to it
# we use git diff --name-status tool to get the names of the changed files
if [[ ! -z "$from" ]] && [[ ! -z "$to" ]]; then
  while IFS= read -r line; do
    echo "$line"

    # fetching the commit status of each file in the commit
    gstatus=$(echo "$line" | awk '{print $1}')

    # but we are only interested in Renamed or Modified files, not the deleted ones
    # place the renamed and modified file names in the declared components array above accordingly
    if [[ "$gstatus" == "R"* ]]; then
      gfile=$(echo "$line" | awk '{print $3}')
      components+=("$gfile")
    elif [[ "$gstatus" != "D" ]]; then
      gfile=$(echo "$line" | awk '{print $2}')
      components+=("$gfile")
    fi
  done < <(git diff --name-status $from $to)

 # apic and charts are deployed
   install-component ${components[@]}	
install-component(){
cd $@
echo "terraform init"
echo "terraform plan"
echo "terraform apply --auto-approve"
}
#if commit is related to data-plane for eu then run that commands for that block
#
#then do cd eu-data-plane/
#        terraform init 
#        terraform plan
#        terraform apply --auto-approve
#
#and then same for the us block of code

