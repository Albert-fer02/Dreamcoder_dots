# Morph Fast Apply - Code Editing

## When to Use morph_edit

Use `morph_edit` instead of native `edit` for:
- Large file changes (500+ lines)
- Multiple scattered changes across file
- Whitespace-sensitive edits
- Refactoring across multiple locations

Use native `edit` for:
- Small, exact text replacements
- Single-line changes

## How It Works

Morph uses lazy edit markers: `// ... existing code ...`

Instead of:
```typescript
// OLD: const old = value;
// NEW: const { new: value2 } = obj;
```

Use:
```typescript
const { new: value2 } = obj; // ... existing code ...
```

This allows partial edits without exact string matching.

## Examples

```
morph_edit({
  path: "src/utils.ts",
  changes: [
    { type: "insert", after: "export function helper()", content: "export function enhanced();" },
    { type: "replace", from: "oldFn", to: "newFn" }
  ]
})
```

## Benefits
- 10,500+ tokens/sec editing speed
- 98% accuracy
- No exact string matching needed
