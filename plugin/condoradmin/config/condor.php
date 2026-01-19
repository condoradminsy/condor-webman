<?php

return [
    'version' => '1.0.0',
    'public_key' => 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuFI9fEXdnGDmcR+nBPxSYrs/nNsRnKX2YAXxr993c6He8nhn+AUTrqWm+RhhYDQWYjzoPwegJD6C39jt6NbFPzkcgbGP6784Pw2wLhswvypSQ8KoTCqFoke1p/sUB5rsUrp5tmsNCk5CuSk+ADJ4tteaAHGJNTuybtHIyMbdENs6WefcRjgi2VVnA6KNfSCpwgcNgbcgipeGjERfC48jNIu37l3MlVCjq8SRRg4sUOcAlhak0n5scbJBTDEm5j3HynoqFoaSYp315ez8d85tZ54jcXrBQVFhU0sriMdfbaZ0oKU6zTPL/CETKKE2tKne9AInneMdXJ8EdiD0RF7IQwIDAQAB',
    'private_key' => 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC4Uj18Rd2cYOZxH6cE/FJiuz+c2xGcpfZgBfGv33dzod7yeGf4BROupab5GGFgNBZiPOg/B6AkPoLf2O3o1sU/ORyBsY/rvzg/DbAuGzC/KlJDwqhMKoWiR7Wn+xQHmuxSunm2aw0KTkK5KT4AMni215oAcYk1O7Ju0cjIxt0Q2zpZ59xGOCLZVWcDoo19IKnCBw2BtyCKl4aMRF8LjyM0i7fuXcyVUKOrxJFGDixQ5wCWFqTSfmxxskFMMSbmPcfKeioWhpJinfXl7Px3zm1nniNxesFBUWFTSyuIx19tpnSgpTrNM8v8IRMooTa0qd70Aied4x1cnwR2IPREXshDAgMBAAECggEABgZ0vc7RldpI3ib7OpK4a0OJE2Tg9XW21uwWdPQBVsEYQpPWCGbScpGqUQvD19hGOiIkkHv8pdQdHEgMwib3I8XkkYbDb5VCfUwUBjotCofNrZ918ezmdmfisOHoecEq76sB1rfCrQw/mR7o4BNpM2n+A7cPfmHB3sObEvY0H39h0BZK0y9485+Zy39JS9DVC5wrIZDAYsIyoeakK2OexJ+R5pE/5LdgwB7gczHM1FE52c86mnNMk/u0qcP3xBjOU74uHHL7MFTeYVhNdIjPKB/VbB3HtCZuyf29lT4+/nF4nM4+3fN9PY7hok6RKSYwpxdGLkMBubEDxrCzCRfE2QKBgQD90Nxxv9tPW69MCk6E4pdtVY4tFzQryMQHVn64Z3xqN3mkg1WpxK65y53E759UvcxBpotX1ucWzSrzmugipc606lCnqeOMkFqLLGh24EUBRepALv7LPWVkYy9M6/0GQJ56FKm7rLlNgPqmneeHX9/TdWJQEIHwU4eBVV306+rOuQKBgQC56EmG4uH4+WMKGM5R2pOP2wp0XlY/l+1ZL/tXCqXvRU3Tp9Zw30P7dUSsv9e4JjWNgjuu0Bha4hLNyRvyP7PvRUhczM9NME5K/peSpyHSs0tWvM7yIRAOYJLPEEQzhGojeriiQzcD6Od1dyGJbirjWSIEe/Ldnfu0uMZ8GQdw2wKBgGoY231FCKS0m6M6j7Xmjgvq/oKEt48x3hd/JXtp7szroZKOP8m2aJ9LqQiAbebba71po8e1EmYqnzCzaSPKkYx4gfyD/JVuZhrVFlnSx6WPlyr7OhC0+mQrPcN2xg7OBjDb4FOOEOt/5cauLPEet45J/C2hqN9P203J5HuT/lQpAoGBAKQFAiIEuHQuqye0XQuwubIZAi9LL/MpepnOkITp+x6QWarckIDDKrqHaxCyrYNmCqeP+FIyfNpqTUbMIWDovTrkOITPmjIy5VCbMGWOGXRJBbZAHKFZdE4K/Fu9sT52nCIzWwSmIrrLWLK1aZxT23j8Idws80h94x4+S7gfaQYzAoGAb2h6sBWfjXNmuXsbUPmGP+oSx343YpBrxsSSIsq58xsGRlrYLXMESa2J5zJZy/ZxAdPuVANMoYCv9A6LZgEBWiTYPdGb1reGJVd7+rIYyrZ387pufsQq00HIqeyl0PwGIVBv1718X8xylgZLZxTB/KnPEf8mrJL5x368qnRL7x8=',
    'sse' => [
        'max_connections_per_user' => 10,
    ],
    'crud' => [
        // 排除的数据表
        'exclude_tables' => [
            'con_system_admin',
            'con_system_admin_log',
            'con_system_attachment',
            'con_system_attachment_type',
            'con_system_config',
            'con_system_config_group',
            'con_system_crontab',
            'con_system_crontab_log',
            'con_system_crud_log',
            'con_system_dict_data',
            'con_system_dict_type',
            'con_system_login_log',
            'con_system_menu_rule',
            'con_system_role',
            'con_system_role_group'
        ]
    ]
];
