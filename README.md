# DSpace

## About

- PostgreSQL is not included in this image;
- Mirage2 resposive theme is enabled;
- SSL disabled;
- Portuguese locale enabled;
- Replication Task Suite is enabled;
- Admin is created by passing the necessary arguments through docker run.

## Usage

docker run -d --link your_postgresql_container:db -p 8080:8080 -e ADMIN=admin_email -e PASS=admin_pass -e FIRSTNAME=admin_firstname -e LASTNAME=admin_lastname governoregionalazores/dspace

