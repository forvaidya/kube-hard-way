#!/bin/bash

# Save OpenTofu Plan Artifacts
# This script saves plan artifacts for audit trails and team collaboration

set -e

# Configuration
PLAN_FILE="plan.tfplan"
ARTIFACTS_DIR="plan-artifacts"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

echo "📋 Saving OpenTofu plan artifacts..."
echo "Timestamp: $TIMESTAMP"
echo ""

# Check if plan file exists
if [ ! -f "$PLAN_FILE" ]; then
    echo "❌ Plan file '$PLAN_FILE' not found!"
    echo "Please run 'tofu plan -out=$PLAN_FILE' first."
    exit 1
fi

# Create artifacts directory
mkdir -p "$ARTIFACTS_DIR"

# Generate plan summary
echo "📝 Generating plan summary..."
cat > "$ARTIFACTS_DIR/plan-summary-$TIMESTAMP.txt" << EOF
📋 OpenTofu Plan Summary
=========================

Generated at: $(date)
Plan file: $PLAN_FILE
Working directory: $(pwd)

EOF

# Add plan details
tofu show -no-color "$PLAN_FILE" >> "$ARTIFACTS_DIR/plan-summary-$TIMESTAMP.txt"

# Generate plan JSON
echo "🔧 Generating plan JSON..."
tofu show -json "$PLAN_FILE" > "$ARTIFACTS_DIR/plan-$TIMESTAMP.json"

# Generate cost estimation
echo "💰 Generating cost estimation..."
cat > "$ARTIFACTS_DIR/cost-estimation-$TIMESTAMP.txt" << EOF
💰 Cost Estimation
==================

Note: This is a basic cost overview based on resource types.
Generated at: $(date)

Resource Changes:
EOF

# Count resource types for cost estimation
tofu show -json "$PLAN_FILE" | jq -r '.resource_changes[] | .type' | sort | uniq -c | while read count resource; do
    echo "$count x $resource" >> "$ARTIFACTS_DIR/cost-estimation-$TIMESTAMP.txt"
done 2>/dev/null || echo "Could not generate cost estimation" >> "$ARTIFACTS_DIR/cost-estimation-$TIMESTAMP.txt"

# Copy the plan file
echo "📁 Copying plan file..."
cp "$PLAN_FILE" "$ARTIFACTS_DIR/plan-$TIMESTAMP.tfplan"

# Create index file
cat > "$ARTIFACTS_DIR/README-$TIMESTAMP.md" << EOF
# OpenTofu Plan Artifacts

Generated: $(date)
Plan file: $PLAN_FILE

## Files:

- **plan-$TIMESTAMP.tfplan** - Binary plan file (use with 'tofu apply')
- **plan-summary-$TIMESTAMP.txt** - Human-readable plan summary
- **plan-$TIMESTAMP.json** - Machine-readable plan in JSON format
- **cost-estimation-$TIMESTAMP.txt** - Resource count and cost overview

## Usage:

\`\`\`bash
# Apply this plan
tofu apply "$ARTIFACTS_DIR/plan-$TIMESTAMP.tfplan"

# View plan details
tofu show "$ARTIFACTS_DIR/plan-$TIMESTAMP.tfplan"

# Parse JSON for automation
jq '.resource_changes[]' "$ARTIFACTS_DIR/plan-$TIMESTAMP.json"
\`\`\`

## Security Note:
Plan files may contain sensitive information. Store securely and limit access.
EOF

# List generated artifacts
echo ""
echo "🎉 Plan artifacts saved to '$ARTIFACTS_DIR/':"
echo "   📁 plan-$TIMESTAMP.tfplan (binary plan)"
echo "   📝 plan-summary-$TIMESTAMP.txt (summary)"
echo "   🔧 plan-$TIMESTAMP.json (JSON format)"
echo "   💰 cost-estimation-$TIMESTAMP.txt (cost overview)"
echo "   📚 README-$TIMESTAMP.md (usage guide)"
echo ""

echo "💡 To apply this plan:"
echo "   tofu apply '$ARTIFACTS_DIR/plan-$TIMESTAMP.tfplan'"
echo ""
echo "💡 To view artifacts:"
echo "   ls -la '$ARTIFACTS_DIR/'"
echo "   cat '$ARTIFACTS_DIR/plan-summary-$TIMESTAMP.txt'"
