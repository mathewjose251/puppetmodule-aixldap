# aixldap
#
# A description of what this class does
#
# @summary Setup AD LDAP Authentication on AIX
#
# @example
#   include aixldap
#### NOTE: defaults are provided with module level hieradata
class aixldap (
  String $base_dn,
  String $bind_dn,
  String $bind_pwd,
  String $serverlist,
  Optional[String] $ssl_ca_cert_content,
  Optional[String] $ssl_ca_cert_source,
  # The rest of these options have reasonable defaults in hiera
  String $auth_type, # hiera
  String $default_loc, # hiera
  String $domain, # hiera
  String $kdb_file, # hiera
  String $kerb_realm, # hiera

  String $pkg_src_baseurl,

  String $ssl_ca_cert_file, # hiera

) {

  # Ensure Local users authenticate locally
  # NOTE: root and virtuser will be handled elsewhere
  $local_users = split($facts['aix_local_users'], ' ')
  $local_users.each |$user| {
    if !defined(User[$user]) {
      user { $user:
        ensure     => 'present',
        attributes => [
          'SYSTEM=compat',
          'registry=files',
        ],
      }
    }
  }

  # Install Packages
  include aixldap::install

  # Configire
  include aixldap::configure

  # Service
  #include aixldap::service

}
