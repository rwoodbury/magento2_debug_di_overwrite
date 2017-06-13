#!/bin/bash

# Install or remove flags for DB query and stack trace logger.

case $1 in
    ''|[Oo][Nn])
        echo 'Turning on DB debug logger.'

        # "app/etc" must exist
        mkdir app/etc/dev

        cat <<CATXML > app/etc/dev/di.xml
<?xml version="1.0"?>
<!--
/**
 * Copyright © 2016 Magento. All rights reserved.
 * See COPYING.txt for license details.
 */
-->
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">
    <preference for="Magento\Framework\DB\LoggerInterface" type="Magento\Framework\DB\Logger\File"/>
    <type name="Magento\Framework\DB\Logger\File">
        <arguments>
            <argument name="logAllQueries" xsi:type="boolean">true</argument>
            <argument name="logQueryTime" xsi:type="number">0.05</argument>
            <argument name="logCallStack" xsi:type="boolean">true</argument>
        </arguments>
    </type>
</config>

CATXML

        php bin/magento cache:clean
        ;;


    [Oo][Ff][Ff])
        echo 'Turning off DB debug logger.'
        rm -rf app/etc/dev
        php bin/magento cache:clean
        ;;
esac
