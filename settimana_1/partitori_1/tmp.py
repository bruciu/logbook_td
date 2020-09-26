import numpy as np

Vin = np.array([8.98449, 6.98741, 4.9888, 2.98626, 0.99112])
dVin = np.array([0.00075, 0.00072, 0.0012, 0.00092, 0.00046])

Vout = np.array([4.9368, 3.83787, 2.7375, 1.63710, 0.5383])
dVout = np.array([0.0012, 0.00083, 0.0013, 0.0013, 0.0013])


Vin_Vout = Vin / Vout
dVint_Vout = np.sqrt((dVin / Vout)**2 + (dVout * Vin / (2 * Vout**2))**2)

for i in range(0, len(Vin)):
    print("%f +- %f" %(Vin_Vout[i], dVint_Vout[i]))



Vin2 = np.array([8.9918, 6.99229, 4.99234, 2.98828, 0.99116])
dVin2 = np.array([0.0024, 0.00071, 0.00084, 0.00005, 0.00034])

Vout2 = np.array([1.6005, 1.2424, 0.8827, 0.5236, 0.1656])
dVout2 = np.array([0.0015, 0.0015, 0.0015, 0.0015, 0.0015])


Vin_Vout2 = Vin2 / Vout2
dVint_Vout2 = np.sqrt((dVin2 / Vout2)**2 + (dVout2 * Vin2 / (2 * Vout2**2))**2)

print("\n\n\n")
for i in range(0, len(Vin2)):
    print("%f +- %f" %(Vin_Vout2[i], dVint_Vout2[i]))
