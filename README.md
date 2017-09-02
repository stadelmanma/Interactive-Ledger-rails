# Interactive Ledger


## Overview

This is a lightweight expense tracking and reporting application that allows the user to upload transactions from a bank account, credit card, etc. and view them in a single place. Totals by category and subcategory are automatically calculated per week and for the ledger as a whole. There is a budget system current under development that allows the user to match the data stored in one or more ledgers to expected expenses entered in advance.

### Parsing Uploaded Files
Data file parsers are currently housed in `app/helpers/ledger_upload_helper.rb` and inherit from the `DefaultFormat` class. The current API to add new file format parsers is not ideal and needs to be re-factored into a more user friendly format in the future.

### Ledger Screenshot
![ledger image](/public/ledger-screenshot "Example Ledger")

### Budget Screenshot
![budget image](/public/budget-screenshot "Example Budget")

### Category Initializers
Category Initializers are used to automatically assign a category and optionally a subcategory to any expenses during initial upload. The description is checked by a regular expression pattern match in order of the priority assigned to the initializer with higher priority Initializers tested first. The search is stopped after the first match is found.

![category initializers image](/public/category-initializers-screenshot "Category Initializers")


## Dependencies
* Ruby version 2.4 or greater
* Rails version 5.0 or greater
* Bundler is used to manage gems
* MySQL Database for storage


## Deployment
Capistrano is used for deployment. My current setup is to deploy to an ngnix server hosted locally on a Raspberry Pi. However, this is hardly set in stone and can be configured as desired by the end user. For initial deployment the rake task `bundle exec cap production deploy:initial` was used.


## Testing
A test suite has not been developed yet, `rubocop` is used to evaluate the code syntax.
