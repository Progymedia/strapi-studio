#!/bin/bash
# Force start from root folder
cd "$(dirname "$0")/.."
set -e

# Configuration
PACKAGE_NAME="@progymedia/strapi-studio"
GITHUB_REPO="progymedia/strapi-studio"
NPM_REGISTRY="https://registry.npmjs.org/"

# Function to validate version type
validate_version_type() {
    case $1 in
        major|minor|patch) return 0 ;;
        *) return 1 ;;
    esac
}

# Ask for version type
while true; do
    read -p "Enter version type (major, minor, patch): " VERSION_TYPE
    if validate_version_type $VERSION_TYPE; then
        break
    else
        echo "Invalid version type. Please enter major, minor, or patch."
    fi
done

# Clean and build
echo "Cleaning and building the package..."
yarn nx run-many --target=clean --nx-ignore-cycles || { echo "Clean failed"; exit 1; }
yarn nx run-many --target=build --nx-ignore-cycles || { echo "Build failed"; exit 1; }

# Update version and get new version number
echo "Updating version..."
NEW_VERSION=$(npm version $VERSION_TYPE --no-git-tag-version)
echo "New version: $NEW_VERSION"

# Publish package
echo "Publishing $PACKAGE_NAME$NEW_VERSION to NPM..."
npm publish --access restricted || { echo "Publish failed"; exit 1; }

# Git operations
echo "Committing version change..."
git add package.json
git commit -m "chore: bump version to $NEW_VERSION"

echo "Pushing changes to GitHub..."
git push origin HEAD || { echo "Git push failed"; exit 1; }

echo "Creating and pushing new tag..."
git tag $NEW_VERSION
git push origin $NEW_VERSION || { echo "Git tag push failed"; exit 1; }

echo "Publication process completed for $PACKAGE_NAME$NEW_VERSION"