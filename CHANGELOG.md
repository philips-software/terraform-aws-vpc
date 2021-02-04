# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [2.2.0] = 04-02-2021

- fix CI
- fix S3 endpoint service

## [2.1.0] - 08-04-2020
- Added: Adding subnets taggings capability when creating a VPC (#14)
- Changed: Default vor `enable_create_defaults` from `true` to `false`.

## [2.0.0] - 03-09-2019
- Upgrade to terraform 0.12, Migration directions:
  - Ensure you are on vpc 1.5.0.
  - Ensure you update Terraform to 0.12.
  - Ensure you providers are update to Terraform 0.12 compatible version.
  - Migrate your code via `terraform 0.12 upgrade`.
  

## [1.5.0] - 17-07-2019
- Add example using Terraform 0.12.
- Updates to make module Terraform 0.12 compatible.

## [1.4.0] - 10-07-2019
- Make automatically created (default) resources managed by Terraform (ACL, SG and RT)
- Add tags to all created resources.

## [1.3.0] - 10-04-2019
### Added
- Add S3 VPC endpoint by default so the access to S3 is free from within the VPC.
### Changed
- Updated terraform versions in example.
- Removed provider from module.

## [1.2.1] - 20-12-2018
### Changed
- Rewrite aws_route53_zone resource to remove deprecated vpc_id

## [1.2.0] - 11-10-2018
### Added
- Added condition for the EIP

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

[Unreleased]: https://github.com/philips-software/terraform-aws-vpc/compare/2.2.0...HEAD
[2.2.0]: https://github.com/philips-software/terraform-aws-vpc/compare/2.1.0...2.2.0
[2.1.0]: https://github.com/philips-software/terraform-aws-vpc/compare/2.10.0...2.1.0
[2.0.0]: https://github.com/philips-software/terraform-aws-vpc/compare/1.5.0...2.0.0
[1.5.0]: https://github.com/philips-software/terraform-aws-vpc/compare/1.4.0...1.5.0
[1.4.0]: https://github.com/philips-software/terraform-aws-vpc/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/philips-software/terraform-aws-vpc/compare/1.2.1...1.3.0
[1.2.1]: https://github.com/philips-software/terraform-aws-vpc/compare/1.2.0...1.2.1
[1.2.0]: https://github.com/philips-software/terraform-aws-vpc/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/philips-software/terraform-aws-vpc/compare/1.0.0...1.1.0
