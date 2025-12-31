# Data Model: Scan UX States

## Entities

### ScanSession

- **Purpose**: Represents a user visit to the scan screen and the current UI state.
- **Fields**:
  - `id` (string)
  - `openedAt` (timestamp)
  - `state` (enum: normal, initializing, camera_unavailable, permission_denied, disabled)
  - `imageIds` (list of ScanImage ids)
  - `lastUpdatedAt` (timestamp)
  - `sourceScreen` (string, optional)
- **Validation**:
  - `state` must be one of the supported scan states.

### ScanImage

- **Purpose**: Captured or selected image metadata used for preview and processing.
- **Fields**:
  - `id` (string)
  - `source` (enum: camera, gallery)
  - `filePath` (string)
  - `thumbnailPath` (string, optional)
  - `sizeBytes` (integer)
  - `createdAt` (timestamp)
  - `status` (enum: queued, processing, processed, failed)
  - `failureReason` (string, optional)
- **Validation**:
  - `filePath` must exist when status is queued/processing.
  - `sizeBytes` must be within configured max size; oversize is rejected or downscaled.

### ScanQueueItem

- **Purpose**: Offline queue item for deferred processing.
- **Fields**:
  - `id` (string)
  - `scanImageId` (string)
  - `queuedAt` (timestamp)
  - `retryCount` (integer)
  - `lastAttemptAt` (timestamp, optional)
  - `status` (enum: queued, processing, failed)
- **Validation**:
  - `scanImageId` must reference an existing ScanImage.
  - `retryCount` is non-negative.

### PermissionState

- **Purpose**: Captures current permission state for camera and photo access.
- **Fields**:
  - `cameraStatus` (enum: granted, denied, restricted, limited, unknown)
  - `photoStatus` (enum: granted, denied, restricted, limited, unknown)
  - `lastCheckedAt` (timestamp)

### FeatureFlag

- **Purpose**: Remote-configurable feature toggles for scan disablement.
- **Fields**:
  - `name` (string, e.g., `scan_enabled`)
  - `enabled` (boolean)
  - `source` (string)
  - `updatedAt` (timestamp)

## Relationships

- `ScanSession` has many `ScanImage`.
- `ScanQueueItem` references a single `ScanImage`.
