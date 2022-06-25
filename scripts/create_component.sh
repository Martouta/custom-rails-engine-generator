#!/bin/bash

if [ "$1" == "" ]; then
    exit 1
fi

set -e

script_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
web_path="$script_path/.."
component_path=${2-"$web_path/components/$1"}

echo "(Re)Generating engine/component '$1' in '$component_path'"

rm -rf $component_path

rails plugin new $1 --mountable --skip-listen --skip-active-record --skip-sprockets \
                    --skip-git --skip-gemspec \
                    --skip-action-mailer --skip-action-mailbox --skip-action-text \
                    --skip-active-job --skip-active-storage --skip-action-cable \
                    --skip-turbolinks --skip-jbuilder --skip-gemfile-entry

mv "$web_path/$1" $component_path

mkdir -p $component_path/scripts

rm -rf $component_path/.git \
       $component_path/app/assets \
       $component_path/app/views \
       $component_path/app/helpers \
       $component_path/lib/tasks \
       $component_path/test/dummy \
       $component_path/test/integration \
       $component_path/app/controllers/concerns \
       $component_path/app/models/concerns \
       $component_path/test/mailers \
       $component_path/test/helpers
rm $component_path/README.md

ruby -r $web_path/template/plugin/generator.rb \
     -e "Web::Template::Plugin::Generator.new('$1', '$component_path').call!"
rubocop -A $component_path
chmod -R +x $component_path/scripts
chmod -R +x $component_path/bin

echo 'Finished successfully'

exit 0
