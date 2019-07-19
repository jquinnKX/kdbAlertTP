dxOrderPublic:`transactTime`sym`eventID`orderID`executionOptions`eventType`orderType`side`limitPrice`originalQuantity`grossNotionalValue`fillPrice`fillQuantity`totalExecQuantity`remainingQuantity`avgPrice`sourceFile xcol ([]`timestamp$();`symbol$();`long$();`long$();`symbol$();`symbol$();`symbol$();`symbol$();`float$();`float$();`float$();`float$();`float$();`float$();`float$();`float$();`symbol$())
dxTradePublic:`transactTime`sym`eventID`eventType`price`quantity`buyOrderID`sellOrderID`sourceFile xcol ([]`timestamp$();`symbol$();`long$();`symbol$();`float$();`float$();`long$();`long$();`symbol$());
dxAlert:`transactTime`sym`alertTime`alertEngine`eventID`orderID`executionOptions`eventType`orderType`orderCount`totalOrderQty`totalOrderValue`tradeCount`totalTradeQty`totalTradeValue xcol ([]`timestamp$();`symbol$();`timestamp$();`symbol$();`long$();`long$();`symbol$();`symbol$();`symbol$();`long$();`float$();`float$();`long$();`float$();`float$());
dxStats:`transactTime`sym`frequency`analytic`startTime`endTime`dataStart`dataEnd`timeUsed`spaceUsed`memUsedBefore`memUsedAfter`heapBefore`heapAfter xcol ([]`timestamp$();`symbol$();`timespan$();`symbol$();`timestamp$();`timestamp$();`timestamp$();`timestamp$();`long$();`long$();`long$();`long$();`long$();`long$());
dxReplayStatus:`transactTime`sym xcol ([]`timestamp$();`symbol$());


.schema.schemas:(`dxOrderPublic`dxTradePublic`dxAlert`dxStats`dxReplayStatus)!(dxOrderPublic;dxTradePublic;dxAlert;dxStats;dxReplayStatus);
