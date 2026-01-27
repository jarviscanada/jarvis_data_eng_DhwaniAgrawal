\c host_agent;
CREATE TABLE host_info (
    id SERIAL PRIMARY KEY,
    hostname VARCHAR(255) NOT NULL,
    cpu_number INT NOT NULL,
    cpu_architecture VARCHAR(50) NOT NULL,
    cpu_model VARCHAR(255) NOT NULL,
    cpu_mhz REAL NOT NULL,
    l2_cache VARCHAR(50),
    total_mem BIGINT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE host_usage (
    id SERIAL PRIMARY KEY,
    hostname VARCHAR(255) NOT NULL,
    cpu_usage REAL NOT NULL,
    mem_usage BIGINT NOT NULL,
    disk_usage BIGINT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

