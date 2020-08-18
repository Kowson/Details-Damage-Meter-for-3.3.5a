DETAILS_STORAGE_VERSION = 1

function _details:CreateStorageDB()
	DetailsDataStorage = {VERSION = DETAILS_STORAGE_VERSION, RAID_STORAGE = {}}
	return DetailsDataStorage
end

DetailsDataStorage = DetailsDataStorage or _details:CreateStorageDB()

if (DetailsDataStorage.VERSION < DETAILS_STORAGE_VERSION) then
	--> do revisions
end
