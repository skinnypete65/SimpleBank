postgres:
	docker run --name postgres12 -p 5440:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 --network bank-network createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	 migrate -path db/migration -database "postgresql://root:secret@localhost:5440/simple_bank?sslmode=disable" --verbose up

migrateup1:
	 migrate -path db/migration -database "postgresql://root:secret@localhost:5440/simple_bank?sslmode=disable" --verbose up 1

migratedown:
	 migrate -path db/migration -database "postgresql://root:secret@localhost:5440/simple_bank?sslmode=disable" --verbose down

migratedown1:
	 migrate -path db/migration -database "postgresql://root:secret@localhost:5440/simple_bank?sslmode=disable" --verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -destination db/mock/store.go -package mockdb SimpleBank/db/sqlc Store

.PHONY: postgres, createdb, dropdb, migrateup, migrateup1, migratedown, migratedown1, sqlc, test, server, mock