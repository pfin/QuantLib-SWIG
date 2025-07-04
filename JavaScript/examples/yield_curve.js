// Yield Curve Construction Example
// Shows how to build a yield curve using QuantLib JavaScript bindings

const QuantLib = require('../index');

console.log('=== QuantLib Yield Curve Example ===\n');

// Memory tracking helper
const objects = [];
function track(obj) {
    objects.push(obj);
    return obj;
}

try {
    // Set evaluation date
    const today = track(QuantLib.Date.todaysDate());
    QuantLib.Settings.instance().setEvaluationDate(today);
    
    // Create calendar and day counter
    const calendar = track(new QuantLib.TARGET());
    const dayCounter = track(new QuantLib.Actual360());
    
    // Market data - deposit rates
    const depositRates = [
        { tenor: '1W', rate: 0.0382 },
        { tenor: '1M', rate: 0.0372 },
        { tenor: '3M', rate: 0.0363 },
        { tenor: '6M', rate: 0.0353 },
    ];
    
    // Market data - swap rates
    const swapRates = [
        { tenor: '1Y', rate: 0.0349 },
        { tenor: '2Y', rate: 0.0348 },
        { tenor: '3Y', rate: 0.0347 },
        { tenor: '5Y', rate: 0.0346 },
        { tenor: '10Y', rate: 0.0346 },
    ];
    
    // Create rate helpers
    const rateHelpers = [];
    
    // Deposit rate helpers
    console.log('Adding deposit rates:');
    depositRates.forEach(({ tenor, rate }) => {
        const period = track(QuantLib.Period.fromString(tenor));
        const quote = track(new QuantLib.SimpleQuote(rate));
        const helper = track(new QuantLib.DepositRateHelper(
            quote,
            period,
            2, // fixing days
            calendar,
            QuantLib.ModifiedFollowing,
            true, // end of month
            dayCounter
        ));
        rateHelpers.push(helper);
        console.log(`  ${tenor}: ${(rate * 100).toFixed(2)}%`);
    });
    
    // Swap rate helpers
    console.log('\nAdding swap rates:');
    const swapIndex = track(new QuantLib.Euribor6M());
    swapRates.forEach(({ tenor, rate }) => {
        const period = track(QuantLib.Period.fromString(tenor));
        const quote = track(new QuantLib.SimpleQuote(rate));
        const helper = track(new QuantLib.SwapRateHelper(
            quote,
            period,
            calendar,
            QuantLib.Annual,
            QuantLib.ModifiedFollowing,
            dayCounter,
            swapIndex
        ));
        rateHelpers.push(helper);
        console.log(`  ${tenor}: ${(rate * 100).toFixed(2)}%`);
    });
    
    // Build the curve
    console.log('\nBuilding yield curve...');
    const yieldCurve = track(new QuantLib.PiecewiseLogLinearDiscount(
        today,
        rateHelpers,
        dayCounter
    ));
    
    // Extract discount factors
    console.log('\nDiscount factors:');
    const dates = [1, 30, 90, 180, 365, 730, 1095, 1825, 3650];
    dates.forEach(days => {
        const date = track(calendar.advance(today, days, QuantLib.Days));
        const df = yieldCurve.discount(date);
        const rate = yieldCurve.zeroRate(date, dayCounter, QuantLib.Continuous).rate();
        console.log(`  ${days} days: DF = ${df.toFixed(6)}, Zero Rate = ${(rate * 100).toFixed(3)}%`);
    });
    
    // Calculate forward rates
    console.log('\nForward rates:');
    const fwdPeriods = [
        { start: 90, end: 180 },
        { start: 180, end: 270 },
        { start: 365, end: 730 },
    ];
    
    fwdPeriods.forEach(({ start, end }) => {
        const startDate = track(calendar.advance(today, start, QuantLib.Days));
        const endDate = track(calendar.advance(today, end, QuantLib.Days));
        const fwdRate = yieldCurve.forwardRate(
            startDate, endDate, dayCounter, QuantLib.Simple
        ).rate();
        console.log(`  ${start}d-${end}d: ${(fwdRate * 100).toFixed(3)}%`);
    });
    
} catch (error) {
    console.error('Error:', error.message);
} finally {
    // Clean up all tracked objects
    console.log('\nCleaning up memory...');
    objects.forEach(obj => {
        if (obj && typeof obj.delete === 'function') {
            obj.delete();
        }
    });
    console.log('Memory cleaned up successfully!');
}

console.log('\nExample completed!');