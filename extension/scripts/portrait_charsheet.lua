--
-- Custom portrait handler for HarnMaster character sheet.
-- Uses tokenfield with drawmode=fit to render the raw portrait asset
-- at the control's full size (140x210), bypassing the portraitset system.
-- Adapted from CoreRPG picture_asset.lua.
--

function onClickDown()
	return true;
end

function onClickRelease()
	return RecordAssetManager.handlePicturePressed(window.getDatabaseNode(), window);
end

function onDragStart(_, _, _, draginfo)
	return RecordAssetManager.handlePictureDragStart(window.getDatabaseNode(), draginfo);
end

function onDrop(_, _, draginfo)
	return RecordAssetManager.handlePictureDrop(window.getDatabaseNode(), draginfo);
end
