
# CRAN Package Summarizer

This application indexes packages for the programming language `R`.

It collates information from the [CRAN server network](https://cran.r-project.org/) and stores them on a `packages` table in a Postgres database.

## Install

1. Install the Ruby version from `.ruby-version`
1. Install Postgres
1. `bundle install`
1. `rails db:setup`
1. `bin/rails console` to prove that it runs
1.  `bundle exec rspec` to run tests

## Overview
There is one database-backed model, `Package`, and two major service objects: `CreatePackagesFromList` which create packages using data taken from the list file on the CRAN server, and `UpdatePackageDetails`, which fetches more details about each package.

To populate the database, call the parent service - `RecreateAllPackages.new.call` - in the Rails console. This service is also scheduled to run once a day (see `config/schedule.rb`).

## Improvements

This is a working MVP, but there are some areas that could be improved in further iterations:

- *Efficiency:* Currently, the entire database of packages is re-created every day. This works, but it's wasteful because most packages won't have changed. We could improve this in two steps:

    1. Create a local copy of the PACKAGES list file. Before resetting the database, check whether the list file on the server is still identical to the one we have locally. If it is, then we can assume nothing has changed and our local database still matches the information on the server, so we don't need to recreate the database.

    1. Only change those packages which have been updated on the server. Rather than updating **every** package everyday, we could use the PACKAGES list file to see which packages have a new version, and only trigger updates for those packages.

- *Handling incorrect URLs*: The URLs for the package archives follow a pattern: `package-name_version-number`. But not every package follows this pattern - sometimes an extra `0` is added to the end of the version number. For example, the URL for package `anesrake` version `0.8` is actually [anesrake_0.80](https://cran.r-project.org/src/contrib/anesrake_0.80.tar.gz) rather than [anesrake_0.8](https://cran.r-project.org/src/contrib/anesrake_0.8.tar.gz). Currently, the application rescues the HTTP error and logs that the URL was incorrect, but a more elegant solution would be to automatically try common variations of the URL until one is succesful.

- *Memory*: The list file is quite large, and we load it all into memory. It would be better to save it locally, then iterate over smaller chunks to create the records.

- *Better Database fields:* Almost every field is stored as text. This is inconvenient if you want to do interesting stuff with your data - for example if you want to compare version numbers, or compare authors between packages. 
