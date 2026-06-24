const dbName = process.env.DB_NAME;
const collectionName = process.env.COLLECTION_NAME;
const indexName = process.env.INDEX_NAME;
const indexKeysList = JSON.parse(process.env.INDEX_KEYS || "[]");
const unique = process.env.UNIQUE === "true";

if (!dbName) throw new Error("Missing DB_NAME environment variable");
if (!collectionName) throw new Error("Missing COLLECTION_NAME environment variable");
if (!indexName) throw new Error("Missing INDEX_NAME environment variable");

if (!Array.isArray(indexKeysList) || indexKeysList.length === 0) {
  throw new Error("INDEX_KEYS must be a non-empty JSON array");
}

const database = db.getSiblingDB(dbName);
const collection = database.getCollection(collectionName);

const indexKeys = {};
indexKeysList.forEach((key) => {
  indexKeys[key] = 1;
});

const existingIndex = collection.getIndexes().find((index) => {
  return index.name === indexName ||
    JSON.stringify(index.key) === JSON.stringify(indexKeys);
});

if (existingIndex) {
  print(`Index already exists: ${dbName}.${collectionName}.${existingIndex.name}`);
} else {
  const result = database.runCommand({
    createIndexes: collectionName,
    indexes: [
      {
        key: indexKeys,
        name: indexName,
        unique: unique
      }
    ]
  });

  printjson(result);
}