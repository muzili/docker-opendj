pre_start_action() {
    cd /opt/opendj
    ./setup --cli -v \
            --ldapPort 389 \
            --ldapsPort 636 \
            --adminConnectorPort 4444 \
            --rootUserDN "$LDAP_ROOT_DN" \
            --rootUserPassword $LDAP_ROOT_PASS \
            --generateSelfSignedCertificate \
            --no-prompt --noPropertiesFile \
            --doNotStart

    echo "Configuration finished."
}

post_start_action() {
    rm /first_run
}
