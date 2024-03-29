/*
 * OSGIManagerView.java
 */

package osgimanager;

import org.jdesktop.application.Action;
import org.jdesktop.application.ResourceMap;
import org.jdesktop.application.SingleFrameApplication;
import org.jdesktop.application.FrameView;
import org.jdesktop.application.TaskMonitor;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import javax.swing.Timer;
import javax.swing.Icon;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
import org.eclipse.core.runtime.adaptor.EclipseStarter;
import org.osgi.framework.Bundle;
import org.osgi.framework.BundleContext;
import org.osgi.framework.BundleException;

/**
 * The application's main frame.
 */
public class OSGIManagerView extends FrameView {

    private BundleContext _context;
    private boolean _framework_status = false;

    public OSGIManagerView(SingleFrameApplication app) {
        super(app);

        initComponents();

        // status bar initialization - message timeout, idle icon and busy animation, etc
        ResourceMap resourceMap = getResourceMap();
        int messageTimeout = resourceMap.getInteger("StatusBar.messageTimeout");
        messageTimer = new Timer(messageTimeout, new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                statusMessageLabel.setText("");
            }
        });
        messageTimer.setRepeats(false);
        int busyAnimationRate = resourceMap.getInteger("StatusBar.busyAnimationRate");
        for (int i = 0; i < busyIcons.length; i++) {
            busyIcons[i] = resourceMap.getIcon("StatusBar.busyIcons[" + i + "]");
        }
        busyIconTimer = new Timer(busyAnimationRate, new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                busyIconIndex = (busyIconIndex + 1) % busyIcons.length;
                statusAnimationLabel.setIcon(busyIcons[busyIconIndex]);
            }
        });
        idleIcon = resourceMap.getIcon("StatusBar.idleIcon");
        statusAnimationLabel.setIcon(idleIcon);
        progressBar.setVisible(false);

        // connecting action tasks to status bar via TaskMonitor
        TaskMonitor taskMonitor = new TaskMonitor(getApplication().getContext());
        taskMonitor.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                String propertyName = evt.getPropertyName();
                if ("started".equals(propertyName)) {
                    if (!busyIconTimer.isRunning()) {
                        statusAnimationLabel.setIcon(busyIcons[0]);
                        busyIconIndex = 0;
                        busyIconTimer.start();
                    }
                    progressBar.setVisible(true);
                    progressBar.setIndeterminate(true);
                } else if ("done".equals(propertyName)) {
                    busyIconTimer.stop();
                    statusAnimationLabel.setIcon(idleIcon);
                    progressBar.setVisible(false);
                    progressBar.setValue(0);
                } else if ("message".equals(propertyName)) {
                    String text = (String)(evt.getNewValue());
                    statusMessageLabel.setText((text == null) ? "" : text);
                    messageTimer.restart();
                } else if ("progress".equals(propertyName)) {
                    int value = (Integer)(evt.getNewValue());
                    progressBar.setVisible(true);
                    progressBar.setIndeterminate(false);
                    progressBar.setValue(value);
                }
            }
        });
    }

    @Action
    public void showAboutBox() {
        if (aboutBox == null) {
            JFrame mainFrame = OSGIManagerApp.getApplication().getMainFrame();
            aboutBox = new OSGIManagerAboutBox(mainFrame);
            aboutBox.setLocationRelativeTo(mainFrame);
        }
        OSGIManagerApp.getApplication().show(aboutBox);
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        mainPanel = new javax.swing.JPanel();
        bt_start_stop = new javax.swing.JButton();
        bt_refresh_bundles = new javax.swing.JButton();
        bt_install_bundle = new javax.swing.JButton();
        bt_uninstall_bundle = new javax.swing.JButton();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jScrollPane1 = new javax.swing.JScrollPane();
        table_bundles = new javax.swing.JTable();
        bt_start_bundle = new javax.swing.JButton();
        bt_stop_bundle = new javax.swing.JButton();
        menuBar = new javax.swing.JMenuBar();
        javax.swing.JMenu fileMenu = new javax.swing.JMenu();
        javax.swing.JMenuItem exitMenuItem = new javax.swing.JMenuItem();
        javax.swing.JMenu helpMenu = new javax.swing.JMenu();
        javax.swing.JMenuItem aboutMenuItem = new javax.swing.JMenuItem();
        statusPanel = new javax.swing.JPanel();
        javax.swing.JSeparator statusPanelSeparator = new javax.swing.JSeparator();
        statusMessageLabel = new javax.swing.JLabel();
        statusAnimationLabel = new javax.swing.JLabel();
        progressBar = new javax.swing.JProgressBar();

        mainPanel.setName("mainPanel"); // NOI18N

        org.jdesktop.application.ResourceMap resourceMap = org.jdesktop.application.Application.getInstance(osgimanager.OSGIManagerApp.class).getContext().getResourceMap(OSGIManagerView.class);
        bt_start_stop.setText(resourceMap.getString("bt_start_stop.text")); // NOI18N
        bt_start_stop.setName("bt_start_stop"); // NOI18N
        bt_start_stop.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bt_start_stopMouseClicked(evt);
            }
        });

        bt_refresh_bundles.setText(resourceMap.getString("bt_refresh_bundles.text")); // NOI18N
        bt_refresh_bundles.setEnabled(false);
        bt_refresh_bundles.setName("bt_refresh_bundles"); // NOI18N
        bt_refresh_bundles.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bt_refresh_bundlesMouseClicked(evt);
            }
        });

        bt_install_bundle.setText(resourceMap.getString("bt_install_bundle.text")); // NOI18N
        bt_install_bundle.setActionCommand(resourceMap.getString("bt_install_bundle.actionCommand")); // NOI18N
        bt_install_bundle.setEnabled(false);
        bt_install_bundle.setName("bt_install_bundle"); // NOI18N
        bt_install_bundle.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bt_install_bundleMouseClicked(evt);
            }
        });

        bt_uninstall_bundle.setText(resourceMap.getString("bt_uninstall_bundle.text")); // NOI18N
        bt_uninstall_bundle.setActionCommand(resourceMap.getString("bt_uninstall_bundle.actionCommand")); // NOI18N
        bt_uninstall_bundle.setEnabled(false);
        bt_uninstall_bundle.setName("bt_uninstall_bundle"); // NOI18N
        bt_uninstall_bundle.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bt_uninstall_bundleMouseClicked(evt);
            }
        });

        jScrollPane2.setName("jScrollPane2"); // NOI18N

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jTable1.setName("jTable1"); // NOI18N
        jScrollPane2.setViewportView(jTable1);

        jScrollPane1.setName("jScrollPane1"); // NOI18N

        table_bundles.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null}
            },
            new String [] {
                "Bundle", "Index", "State"
            }
        ));
        table_bundles.setName("table_bundles"); // NOI18N
        jScrollPane1.setViewportView(table_bundles);

        bt_start_bundle.setText(resourceMap.getString("bt_start_bundle.text")); // NOI18N
        bt_start_bundle.setEnabled(false);
        bt_start_bundle.setName("bt_start_bundle"); // NOI18N
        bt_start_bundle.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bt_start_bundleMouseClicked(evt);
            }
        });

        bt_stop_bundle.setText(resourceMap.getString("bt_stop_bundle.text")); // NOI18N
        bt_stop_bundle.setEnabled(false);
        bt_stop_bundle.setName("bt_stop_bundle"); // NOI18N
        bt_stop_bundle.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bt_stop_bundleMouseClicked(evt);
            }
        });

        org.jdesktop.layout.GroupLayout mainPanelLayout = new org.jdesktop.layout.GroupLayout(mainPanel);
        mainPanel.setLayout(mainPanelLayout);
        mainPanelLayout.setHorizontalGroup(
            mainPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(mainPanelLayout.createSequentialGroup()
                .addContainerGap()
                .add(mainPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                    .add(org.jdesktop.layout.GroupLayout.TRAILING, mainPanelLayout.createSequentialGroup()
                        .add(3, 3, 3)
                        .add(jScrollPane1, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 545, Short.MAX_VALUE)
                        .add(3, 3, 3))
                    .add(mainPanelLayout.createSequentialGroup()
                        .add(mainPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.TRAILING, false)
                            .add(bt_start_bundle, 0, 0, Short.MAX_VALUE)
                            .add(bt_install_bundle, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(mainPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING, false)
                            .add(org.jdesktop.layout.GroupLayout.TRAILING, bt_stop_bundle, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .add(org.jdesktop.layout.GroupLayout.TRAILING, bt_uninstall_bundle, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED, 231, Short.MAX_VALUE)
                        .add(mainPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                            .add(org.jdesktop.layout.GroupLayout.TRAILING, bt_refresh_bundles)
                            .add(org.jdesktop.layout.GroupLayout.TRAILING, bt_start_stop))))
                .addContainerGap())
        );
        mainPanelLayout.setVerticalGroup(
            mainPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(org.jdesktop.layout.GroupLayout.TRAILING, mainPanelLayout.createSequentialGroup()
                .addContainerGap()
                .add(jScrollPane1, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 275, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .add(16, 16, 16)
                .add(mainPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(bt_install_bundle)
                    .add(bt_uninstall_bundle)
                    .add(bt_refresh_bundles))
                .add(mainPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                    .add(mainPanelLayout.createSequentialGroup()
                        .add(7, 7, 7)
                        .add(bt_start_stop))
                    .add(mainPanelLayout.createSequentialGroup()
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.UNRELATED)
                        .add(mainPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                            .add(bt_start_bundle)
                            .add(bt_stop_bundle))))
                .addContainerGap(org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        menuBar.setName("menuBar"); // NOI18N

        fileMenu.setText(resourceMap.getString("fileMenu.text")); // NOI18N
        fileMenu.setName("fileMenu"); // NOI18N

        javax.swing.ActionMap actionMap = org.jdesktop.application.Application.getInstance(osgimanager.OSGIManagerApp.class).getContext().getActionMap(OSGIManagerView.class, this);
        exitMenuItem.setAction(actionMap.get("quit")); // NOI18N
        exitMenuItem.setName("exitMenuItem"); // NOI18N
        fileMenu.add(exitMenuItem);

        menuBar.add(fileMenu);

        helpMenu.setText(resourceMap.getString("helpMenu.text")); // NOI18N
        helpMenu.setName("helpMenu"); // NOI18N

        aboutMenuItem.setAction(actionMap.get("showAboutBox")); // NOI18N
        aboutMenuItem.setName("aboutMenuItem"); // NOI18N
        helpMenu.add(aboutMenuItem);

        menuBar.add(helpMenu);

        statusPanel.setName("statusPanel"); // NOI18N

        statusPanelSeparator.setName("statusPanelSeparator"); // NOI18N

        statusMessageLabel.setName("statusMessageLabel"); // NOI18N

        statusAnimationLabel.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        statusAnimationLabel.setName("statusAnimationLabel"); // NOI18N

        progressBar.setName("progressBar"); // NOI18N

        org.jdesktop.layout.GroupLayout statusPanelLayout = new org.jdesktop.layout.GroupLayout(statusPanel);
        statusPanel.setLayout(statusPanelLayout);
        statusPanelLayout.setHorizontalGroup(
            statusPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(statusPanelSeparator, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 585, Short.MAX_VALUE)
            .add(statusPanelLayout.createSequentialGroup()
                .addContainerGap()
                .add(statusMessageLabel)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED, 389, Short.MAX_VALUE)
                .add(progressBar, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(statusAnimationLabel)
                .addContainerGap())
        );
        statusPanelLayout.setVerticalGroup(
            statusPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(statusPanelLayout.createSequentialGroup()
                .add(statusPanelSeparator, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 2, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .add(statusPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                    .add(statusMessageLabel)
                    .add(statusAnimationLabel)
                    .add(progressBar, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                .add(3, 3, 3))
        );

        setComponent(mainPanel);
        setMenuBar(menuBar);
        setStatusBar(statusPanel);
    }// </editor-fold>//GEN-END:initComponents

    private void bt_start_stopMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bt_start_stopMouseClicked
        try{

            _framework_status = EclipseStarter.isRunning();


            if(_framework_status){
                EclipseStarter.shutdown();

            }
            else{
                String[] equinoxArgs = {"-console","1234","-noExit"};
                _context = EclipseStarter.startup(equinoxArgs,null);
            }

            changeFrameworkState(EclipseStarter.isRunning());


        }catch(Exception ex){
            System.err.println(ex);
        }



    }//GEN-LAST:event_bt_start_stopMouseClicked

    private void changeFrameworkState(boolean state){

        if(!state){

                DefaultTableModel dfm = new DefaultTableModel();
                table_bundles.setModel(dfm);



                bt_start_stop.setText("Start Framework");
                bt_refresh_bundles.setEnabled(false);
                bt_install_bundle.setEnabled(false);
                bt_uninstall_bundle.setEnabled(false);
                bt_start_bundle.setEnabled(false);
                bt_stop_bundle.setEnabled(false);

            }
            else{
                bt_start_stop.setText("Stop Framework");
                bt_refresh_bundles.setEnabled(true);
                bt_install_bundle.setEnabled(true);
                bt_uninstall_bundle.setEnabled(true);
                bt_start_bundle.setEnabled(true);
                bt_stop_bundle.setEnabled(true);
                refreshTable();
            }



    }

    private void bt_refresh_bundlesMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bt_refresh_bundlesMouseClicked
        refreshTable();
    }//GEN-LAST:event_bt_refresh_bundlesMouseClicked

    private void refreshTable(){
        DefaultTableModel model = new DefaultTableModel();
        model.addColumn("Bundle");
        model.addColumn("Index");
        model.addColumn("State");

        table_bundles.setModel(model);

        for(Bundle b : _context.getBundles()){

            Object[] row = {b.getSymbolicName(), (Long) b.getBundleId(), bundleStateTranslate(b.getState())};
            model.addRow(row);

            System.out.println(b.getSymbolicName() + " " + b.getState());

        }
    }

    private String bundleStateTranslate(int state){

        switch(state){
            case Bundle.ACTIVE:         return "ACTIVE";
            case Bundle.INSTALLED:      return "INSTALLED";
            case Bundle.RESOLVED:       return "RESOLVED";
            case Bundle.STARTING:       return "STARTING";
            case Bundle.STOPPING:       return "STOPPING";
            case Bundle.UNINSTALLED:    return "UNINSTALLED";
            default:                    return "UNKNOWN";
        }


    }

    private void bt_install_bundleMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bt_install_bundleMouseClicked
        JFileChooser jfc = new JFileChooser();

        if(jfc.showOpenDialog(jfc)==JFileChooser.APPROVE_OPTION){
            File f = jfc.getSelectedFile();

            try{
                Bundle bundle = _context.installBundle("file://"+f.getAbsolutePath());
            }catch(Exception ex){
                JOptionPane.showMessageDialog(null, "An error occurred when installing bundle.\n"+ex, "ERROR", JOptionPane.OK_OPTION);
            }
            finally{
                refreshTable();
            }
        }

        
    }//GEN-LAST:event_bt_install_bundleMouseClicked

    private void bt_uninstall_bundleMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bt_uninstall_bundleMouseClicked
        if(table_bundles.getSelectedRow()<0)
            return;

        Long index = new Long(table_bundles.getValueAt(table_bundles.getSelectedRow(), 1).toString());
        Bundle bundle = _context.getBundle(index);

        if(JOptionPane.showConfirmDialog(null, "Want remove?", "Input", JOptionPane.YES_NO_OPTION)==JOptionPane.YES_OPTION){
            try {
                bundle.uninstall();
            } catch (BundleException ex) {
                JOptionPane.showMessageDialog(null, "An error occurred when uninstalling bundle.\n"+ex, "ERROR", JOptionPane.OK_OPTION);
            }
            finally{
                refreshTable();
            }
        }

    }//GEN-LAST:event_bt_uninstall_bundleMouseClicked

    private void bt_start_bundleMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bt_start_bundleMouseClicked
        if(table_bundles.getSelectedRow()<0)
            return;

        long id = (Long) table_bundles.getValueAt(table_bundles.getSelectedRow(), 1);

        Bundle bundle = _context.getBundle(id);
        try {
            bundle.start();
        } catch (BundleException ex) {
            JOptionPane.showMessageDialog(null, "An error occurred when starting bundle.\n"+ex, "ERROR", JOptionPane.OK_OPTION);
        }finally{
            refreshTable();
        }

    }//GEN-LAST:event_bt_start_bundleMouseClicked

    private void bt_stop_bundleMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bt_stop_bundleMouseClicked
        if(table_bundles.getSelectedRow()<0)
            return;


        long id = (Long) table_bundles.getValueAt(table_bundles.getSelectedRow(), 1);
        

        Bundle bundle = _context.getBundle(id);
        try {
            bundle.stop();
        } catch (BundleException ex) {
            JOptionPane.showMessageDialog(null, "An error occurred when stopping bundle.\n"+ex, "ERROR", JOptionPane.OK_OPTION);
        }finally{
            refreshTable();
        }


    }//GEN-LAST:event_bt_stop_bundleMouseClicked
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton bt_install_bundle;
    private javax.swing.JButton bt_refresh_bundles;
    private javax.swing.JButton bt_start_bundle;
    private javax.swing.JButton bt_start_stop;
    private javax.swing.JButton bt_stop_bundle;
    private javax.swing.JButton bt_uninstall_bundle;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTable jTable1;
    private javax.swing.JPanel mainPanel;
    private javax.swing.JMenuBar menuBar;
    private javax.swing.JProgressBar progressBar;
    private javax.swing.JLabel statusAnimationLabel;
    private javax.swing.JLabel statusMessageLabel;
    private javax.swing.JPanel statusPanel;
    private javax.swing.JTable table_bundles;
    // End of variables declaration//GEN-END:variables

    private final Timer messageTimer;
    private final Timer busyIconTimer;
    private final Icon idleIcon;
    private final Icon[] busyIcons = new Icon[15];
    private int busyIconIndex = 0;

    private JDialog aboutBox;
}
