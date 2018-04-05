/**
 * Nutanix Java SDK Test Example
 * 
 * @author Vamsi Krishna
 * @author Andre Leibovici
 * @version 1.0
 */
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

import javax.net.ssl.X509TrustManager;

/**
 * Create a trust manager that will validate any certificate.
 * 
 * @author Vamsi Krishna
 * @version $Revision: 1.0 $
 */
public class NullTrustManager implements X509TrustManager, Cloneable {

	/**
	 * Field ValidServerCertificate.
	 */
	private static Boolean ValidServerCertificate;

	/**
	 * Method getAcceptedIssuers.
	 * 
	 * 
	 * 
	 * @return java.security.cert.X509Certificate[] * @see
	 *         javax.net.ssl.X509TrustManager#getAcceptedIssuers()
	 */
	public java.security.cert.X509Certificate[] getAcceptedIssuers() {
		return null;
	}

	/**
	 * Method checkClientTrusted.
	 * 
	 * @param certs
	 *            java.security.cert.X509Certificate[]
	 * @param authType
	 *            String
	 * 
	 * @see javax.net.ssl.X509TrustManager#checkClientTrusted(java.security.cert.X509Certificate[],
	 *      String)
	 **/
	public void checkClientTrusted(
			final java.security.cert.X509Certificate[] certs,
			final String authType) {

	}

	/**
	 * Method checkServerTrusted.
	 * 
	 * @param certs
	 *            java.security.cert.X509Certificate[]
	 * @param authType
	 *            String
	 * 
	 * @see javax.net.ssl.X509TrustManager#checkServerTrusted(java.security.cert.X509Certificate[],
	 *      String)
	 **/
	public void checkServerTrusted(
			final java.security.cert.X509Certificate[] certs,
			final String authType) {
		if (null != ValidServerCertificate) {
			return;
		}
		for (int i = 0; i < certs.length; i++) {
			final X509Certificate x509Certificate = certs[i];
			try {
				x509Certificate.checkValidity();
				// passed the validity check
				ValidServerCertificate = true;
				return;
			} catch (final CertificateException ce) {
				ValidServerCertificate = false;
			}
		}
	}

	/**
	 * Method toString.
	 * 
	 * @return String
	 */
	@Override
	public String toString() {
		return super.toString();
	}

	/**
	 * Method clone.
	 * 
	 * @return Object
	 * @throws CloneNotSupportedException
	 */
	@Override
	public Object clone() throws CloneNotSupportedException {
		return super.clone();
	}
}