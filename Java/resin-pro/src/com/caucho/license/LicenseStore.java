package com.caucho.license;

import com.caucho.config.ConfigException;
import com.caucho.util.CharBuffer;
import com.caucho.util.L10N;
import com.caucho.vfs.Vfs;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.logging.Level;
import java.util.logging.Logger;

class LicenseStore {
	private static final Logger log = Logger.getLogger(LicenseStore.class
			.getName());

	private static final L10N L = new L10N(LicenseStore.class);
	private File _licenseDirectory;
	private ArrayList<LicenseImpl> _licenses = new ArrayList();

	private Collection<LicenseWrapper> _wrappers = new ArrayList();

	private String _licenseErrors = "";
	private int _personalCount;
	private int _professionalCount;

	LicenseStore() {
		try {
			init(null);
		} catch (Exception e) {
			log.log(Level.FINEST, e.toString(), e);

			this._licenseErrors = e.getMessage();
		}
	}

	LicenseStore(File licenseDirectory) throws ConfigException, IOException {
		init(licenseDirectory);
	}

	public final File getLicenseDirectory() {
		return this._licenseDirectory;
	}

	private void init(File licenseDirectory) throws ConfigException,
			IOException {
		this._licenses.clear();
		this._personalCount = 100;
		this._professionalCount = 100;

		if (licenseDirectory == null) {
			String resinLicenseDir = System.getProperty("resin.license.dir");

			if (resinLicenseDir != null) {
				licenseDirectory = new File(resinLicenseDir);

				if (!licenseDirectory.isDirectory()) {
					licenseDirectory = null;
				}
			}
		}

		if (licenseDirectory == null) {
			File dir = new File(System.getProperty("user.dir") + "/licenses");

			if ((dir.exists()) && (dir.isDirectory()) && (dir.canRead())) {
				licenseDirectory = dir;
			}
		}

		if (licenseDirectory == null) {
			String resinHome = System.getProperty("resin.home");
			String resinRoot = System.getProperty("resin.root");

			if (resinRoot != null) {
				File dir = new File(resinRoot + "/licenses");

				if ((dir.exists()) && (dir.isDirectory()) && (dir.canRead())) {
					licenseDirectory = dir;
				}
			}

			if (licenseDirectory == null) {
				if (resinHome != null)
					licenseDirectory = new File(resinHome + "/licenses");
				else {
					throw new ConfigException(
							L.l("  Resin Professional has not found any valid licenses.\n  resin.home must be defined for license validation."));
				}
			}
		}

		this._licenseDirectory = licenseDirectory;

		if (!licenseDirectory.exists()) {
			throw new ConfigException(
					L.l("  Resin Professional has not found any valid licenses.\n  License directory '{0}' does not exist.",
							licenseDirectory));
		}

		if (!licenseDirectory.isDirectory()) {
			throw new ConfigException(
					L.l("  Resin Professional has not found any valid licenses.\n  License path '{0}' is not a valid directory.",
							licenseDirectory));
		}

		if (!licenseDirectory.canRead()) {
			throw new ConfigException(
					L.l("  Resin Professional has not found any valid licenses.\n  License directory '{0}' is not readable.",
							licenseDirectory));
		}

		addLicenseDirectory(licenseDirectory);
	}

	public final void addLicenseDirectory(File licenseDirectory)
			throws ConfigException, IOException {
		if (licenseDirectory == null) {
			return;
		}
		String[] list = licenseDirectory.list();

		if (list == null) {
			return;
		}
		for (int i = 0; i < list.length; i++) {
			String file = list[i];

			if (!file.endsWith(".license"))
				continue;
			try {
				File license = new File(licenseDirectory, file);

				if (!license.canRead()) {
					throw new ConfigException(L.l(
							"License file '{0}' is not readable.",
							license.toString()));
				}

				LicenseImpl l = new LicenseImpl(license);

				if ((addLicense(l)) && (l.isValid())) {
					this._professionalCount += l.getProfessionalCount();
					this._personalCount += l.getPersonalCount();
				}
			} catch (Exception e) {
				this._licenseErrors += e.getMessage();

				log.log(Level.FINER, e.toString(), e);

				log.info(e.toString());
			}
		}

		this._licenses.trimToSize();

		if (this._professionalCount > 0)
			Vfs.initJNI();
	}

	final Collection<LicenseWrapper> getLicenses() {
		return Collections.unmodifiableCollection(this._wrappers);
	}

	final Collection<License> getLicenseList() {
		ArrayList licenseList = new ArrayList();

		for (License license : this._licenses) {
			licenseList.add(new LicenseData(license));
		}

		return licenseList;
	}

	private boolean addLicense(LicenseImpl license) {
		for (LicenseImpl testLicense : this._licenses) {
			if ((testLicense.getSignature().equals(license.getSignature()))
					&& (testLicense.getSignature31().equals(license
							.getSignature31()))) {
				return false;
			}
		}

		this._licenses.add(license);
		this._wrappers.add(new LicenseWrapper(license));

		return true;
	}

	int getProfessionalCount() {
		return this._professionalCount;
	}

	int getPersonalCount() {
		return this._personalCount;
	}

	final void validate(int professionalCount, int personalCount)
			throws ConfigException {
		if ((professionalCount <= getProfessionalCount())
				&& ((personalCount <= getPersonalCount()) || (personalCount <= getProfessionalCount()))) {
			return;
		}
		String licenseDirectory;
		if (this._licenseDirectory != null)
			licenseDirectory = this._licenseDirectory.toString();
		else {
			licenseDirectory = "$RESIN_HOME/licenses";
		}
		String msg = null;
		if (getProfessionalCount() + getPersonalCount() < 1) {
			msg = L.l(
					"  Resin Professional has not found any valid licenses.\n  Licenses belong in {0}.\n  See http://www.caucho.com/resin/sales for licensing information.\n{1}",
					licenseDirectory, getFullDescription());
		} else if (getProfessionalCount() < professionalCount) {
			msg = L.l(
					"  Resin Professional has found fewer licenses ({0}) than required ({1}).\n  Licenses belong in {2}.\n  See http://www.caucho.com/resin/sales for purchasing information.\n{3}",
					Integer.valueOf(getProfessionalCount()),
					Integer.valueOf(professionalCount), licenseDirectory,
					getFullDescription());
		} else if ((getPersonalCount() < personalCount)
				&& (getProfessionalCount() < personalCount)) {
			msg = L.l(
					"  Resin Personal has found fewer licenses ({0}) than required ({1}).\n  Licenses belong in {2}.\n  See http://www.caucho.com/resin/sales for purchasing information.\n{3}",
					Integer.valueOf(getPersonalCount()),
					Integer.valueOf(personalCount), licenseDirectory,
					getFullDescription());
		}

		throw new ConfigException(msg);
	}

	String doLogging() {
		StringBuilder sb = new StringBuilder();

		boolean hasInvalid = false;

		for (int i = 0; i < this._licenses.size(); i++) {
			LicenseImpl license = (LicenseImpl) this._licenses.get(i);

			if (license.isValid()) {
				sb.append("  " + license.getDescription() + "\n");
			}

		}

		for (int i = 0; i < this._licenses.size(); i++) {
			LicenseImpl license = (LicenseImpl) this._licenses.get(i);

			if (!license.isValid()) {
				if (!hasInvalid) {
					log.warning("");
					sb.append("\nExpired licenses:\n");
				}

				hasInvalid = true;
				log.warning(license.getDescription());
				sb.append("  " + license.getDescription() + "\n");
			}
		}

		if (hasInvalid) {
			log.warning("");
			sb.append("\n");
		}

		if (sb.length() > 0) {
			return sb.toString();
		}
		return "";
	}

	String getFullDescription() {
		StringBuilder sb = new StringBuilder();

		boolean hasInvalid = false;

		for (int i = 0; i < this._licenses.size(); i++) {
			LicenseImpl license = (LicenseImpl) this._licenses.get(i);

			if (license.isValid()) {
				sb.append("  " + license.getDescription() + "\n");
			}

		}

		for (int i = 0; i < this._licenses.size(); i++) {
			LicenseImpl license = (LicenseImpl) this._licenses.get(i);

			if (!license.isValid()) {
				if (!hasInvalid) {
					sb.append("\nExpired licenses:\n");
				}

				hasInvalid = true;
				sb.append("  " + license.getDescription() + "\n");
			}
		}

		if (hasInvalid) {
			sb.append("\n");
		}

		if (sb.length() > 0) {
			return sb.toString();
		}
		return "";
	}

	String getDescription() {
		CharBuffer cb = CharBuffer.allocate();

		for (int i = 0; i < this._licenses.size(); i++) {
			LicenseImpl license = (LicenseImpl) this._licenses.get(i);

			cb.append("  " + license.getDescription() + "\n");
		}

		return cb.toString();
	}

	public String toString() {
		return getClass().getSimpleName() + "[" + getDescription() + "]";
	}
}