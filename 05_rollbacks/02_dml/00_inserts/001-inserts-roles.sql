/* rollback de los roles insertados */

DELETE FROM roles 
WHERE role_id IN (
    '908bcaf5-f138-44a9-84a5-7e127b422631', -- "admin"
    '023067dd-1243-467b-bbf4-6f7a41d27779', -- "user"
    '9b0d6c3d-fba0-4d74-97fb-c9f3f378d778'  -- "operator"
);