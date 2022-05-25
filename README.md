# Custom Rails Engine Generator

A while back I read the book "Component Based Rails Applications" and I found it a treasure.
Now I am working on a project with this CBRA approach.
This repository is extracted from that project.

The purpose of this is not to be bullet-proof, but just a handy way to create components (rails engines) just as custom as I want them. I'm sure that more people can adapt this to your needs.

The dependencies are Rails and Rubocop. Install them with `bundle install`.
Feel free to do it without Rubocop if you prefer to do so.
You do not need to run this script from the path where you have the Rails project.

Run it like:
```
./scripts/create_component.sh component_name component_path
```
The 2nd argument is not mandatory and it defaults to `./components/component_name`

Then it should be added to the Gemfile of the Rails project and optionally generate the graph of dependencies with `cobradeps --graph dependency_graph .`
