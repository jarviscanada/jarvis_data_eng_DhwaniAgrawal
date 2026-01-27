-- Switch to host_agent database
\c host_agent;


-- Table: host_info
CREATE TABLE IF NOT EXISTS public.host_info (
    id SERIAL NOT NULL,
    hostname VARCHAR NOT NULL,
    cpu_number SMALLINT NOT NULL,
    cpu_architecture VARCHAR NOT NULL,
    cpu_model VARCHAR NOT NULL,
    cpu_mhz DOUBLE PRECISION NOT NULL,
    l2_cache INT NOT NULL,
    total_mem INT NOT NULL,
    "timestamp" TIMESTAMP NOT NULL,
    CONSTRAINT host_info_pk PRIMARY KEY (id),
    CONSTRAINT host_info_un UNIQUE (hostname)
);

-- Table: host_usage
-- Stores resource usage data

CREATE TABLE IF NOT EXISTS public.host_usage (
    "timestamp" TIMESTAMP NOT NULL,
    host_id INT NOT NULL,
    memory_free INT NOT NULL,
    cpu_idle SMALLINT NOT NULL,
    cpu_kernel SMALLINT NOT NULL,
    disk_io INT NOT NULL,
    disk_available INT NOT NULL,
    CONSTRAINT host_usage_host_info_fk
        FOREIGN KEY (host_id)
        REFERENCES host_info(id)
);

