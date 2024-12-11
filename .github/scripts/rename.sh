#!/usr/bin/env bash
while getopts r: flag
do
    case "${flag}" in
        r) repo=${OPTARG};;
    esac
done

# Extract the repo name from the full repository path (e.g., "owner/repo-name" -> "repo-name")
urlname=$(echo "$repo" | awk -F '/' '{print $2}')
# Convert to readable name: replace hyphens with spaces and capitalize words
readable_name=$(echo "$urlname" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

echo "Repository: $repo"
echo "URL name: $urlname"
echo "Readable name: $readable_name"

echo "Renaming project..."

temp_repo_name="<<{repo_name}>>"
temp_readable_name="<<{readable_name}>>"
for filename in $(git ls-files) 
do
    sed -i "s/$temp_repo_name/$urlname/g" $filename
    sed -i "s/$temp_readable_name/$readable_name/g" $filename
    echo "Renamed $filename"
done

# Rename package
mv src/package_name src/$urlname

# Change release workflow trigger from none to main
sed -i "s/- none # Automatically changes to main after first push/- main/" .github/workflows/release.yml

# Clear README.md
echo "# $readable_name" > README.md

# Clean up template files
rm -rf .github/scripts/rename.sh
rm -rf .github/workflows/configure_template.yml