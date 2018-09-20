#!/bin/sh

# This script will run a build command of your choice and
# push the subfolder with the subsequent build to the gh-pages branch.
# If you are building an Angular 2+ webapp it will also improve some other things.

# CONFIG

buildcommand="ng build --prod --base-href './'"
subdir="dist"
angularimprovements=1 # 0 or 1


# CODE

if [[ "$(git status)" == *"nothing to commit, working tree clean"* ]]; then

    # remove subfolder from gitignore
    rm -rf $subdir
    sed -i -e "s/\/$subdir/#\/$subdir/g" .gitignore

    # build app
    echo -e "\nNo uncomitted changes, building...\n"
    if eval $buildcommand; then

        echo -e "\nSuccessful build, deploying...\n"

        if [[ angularimprovements -gt 0 ]]; then
            cp "$subdir/index.html" "$subdir/404.html" #adding 404 page allows for refreshing page to work
        fi

        # deploy to Github Pages
        git add .
        git commit -m "Deploy"
        git push origin `git subtree split --prefix $subdir master`:gh-pages --force
        git reset HEAD~

        # reset temp changes
        git checkout -- .
        echo -e "\nDeployed!\n"
        
    else
        git checkout -- .
        echo -e "\nApp failed to build!\n"
    fi

else
    echo -e "\nThere were uncomitted changes! Please commit or discard them before deploying.\n"
fi
