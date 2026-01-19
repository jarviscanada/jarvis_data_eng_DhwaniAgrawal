
tree
ls -l






exit



mkdir -p scripts sql assets
touch README.md scripts/psql_docker.sh scripts/host_info.sh scripts/host_usage.sh sql/ddl.sql sql/queries.sql 

cat << EOF > README.md
# Linux Cluster Monitoring Agent

This project is under development.
Since this project follows GitFlow, the final work will be merged into
the main branch after team code review.
