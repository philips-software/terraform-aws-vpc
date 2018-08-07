# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [1.1.0] - 07-07-2018
### Added
- Add additional tags to public / private subnets to make them usable in Terraform data objects
- Add extra input variable tags, for tagging resources

[1.0.0]
### Added
- Slack badge in documentation
- Refactored route table creation to support updates of routes. The change requires manually updates. See [README.md](README.md)
- Add output variables for route table ids
- Added availability zone to output
- Support for terraform 0.11
- Fix region defaults
- Initial release, based on https://040code.github.io/2017/09/19/talk-immutable-infrastructure/

[Unreleased]: https://github.com/philips-software/terraform-aws-vpc/compare/1.1.0...HEAD
[1.1.0]: https://github.com/philips-software/terraform-aws-vpc/compare/1.0.0...1.1.0
