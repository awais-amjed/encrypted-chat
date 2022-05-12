echo '{
    "projectId": "'$1'",
    "projectName": "'$2'",
    "collections": [
        {
            "$id": "users",
            "$read": [
                "role:member"
            ],
            "$write": [
                "role:member"
            ],
            "name": "Users",
            "enabled": true,
            "permission": "document",
            "attributes": [
                {
                    "key": "name",
                    "type": "string",
                    "status": "available",
                    "required": true,
                    "array": false,
                    "size": 255,
                    "default": null
                },
                {
                    "key": "public_key",
                    "type": "string",
                    "status": "available",
                    "required": false,
                    "array": false,
                    "size": 500,
                    "default": null
                },
                {
                    "key": "chat_ids",
                    "type": "string",
                    "status": "available",
                    "required": false,
                    "array": true,
                    "size": 36,
                    "default": null
                },
                {
                    "key": "image_path",
                    "type": "string",
                    "status": "available",
                    "required": false,
                    "array": false,
                    "size": 100,
                    "default": null
                }
            ],
            "indexes": []
        },
        {
            "$id": "notifications",
            "$read": [
                "role:member"
            ],
            "$write": [
                "role:member"
            ],
            "name": "Notifications",
            "enabled": true,
            "permission": "document",
            "attributes": [
                {
                    "key": "user_ids",
                    "type": "string",
                    "status": "available",
                    "required": true,
                    "array": true,
                    "size": 36,
                    "default": null
                }
            ],
            "indexes": []
        }
    ],
    "functions": [
        {
            "$id": "createUserDocument",
            "name": "Create User Document",
            "runtime": "dart-2.16",
            "path": "functions/Create User Document",
            "entrypoint": "lib/main.dart",
            "execute": [],
            "events": [
                "account.create"
            ],
            "schedule": "",
            "timeout": 15,
            "vars": {
                "endpoint": "'$3'",
                "projectID": "'$1'",
                "apiKey": "'$4'"
            }
        },
        {
            "$id": "createMessageCollection",
            "name": "Create Message Collection",
            "runtime": "dart-2.16",
            "path": "functions/Create Message Collection",
            "entrypoint": "lib/main.dart",
            "execute": [
                "role:member"
            ],
            "events": [],
            "schedule": "",
            "timeout": 15,
            "vars": {
                "endpoint": "'$3'",
                "projectID": "'$1'",
                "apiKey": "'$4'"
            }
        },
        {
            "$id": "notifyUser",
            "name": "Notify User",
            "runtime": "dart-2.16",
            "path": "functions/Notify User",
            "entrypoint": "lib/main.dart",
            "execute": [
                "role:member"
            ],
            "events": [],
            "schedule": "",
            "timeout": 15,
            "vars": {
                "endpoint": "'$3'",
                "projectID": "'$1'",
                "apiKey": "'$4'"
            }
        }
    ]
}' > appwrite.json